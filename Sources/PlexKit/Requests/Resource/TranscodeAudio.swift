//
//  TranscodeAudio.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 31/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

public extension Plex.Request {
    /// - Note: Not designed to be consumed for anything other than playback (e.g. via AVPlayer).
    struct TranscodeAudio: PlexResourceRequest {
        public let path = "music/:/transcode/universal/start.m3u8"
        public let accept = "*/*"

        public var queryItems: [URLQueryItem]? {
            var items: [URLQueryItem] = [
                .init(name: "path", value: "/library/metadata/\(ratingKey)"),
                .init(name: "mediaIndex", value: 0),
                .init(name: "partIndex", value: 0),
                .init(name: "maxAudioBitrate", value: preferredBitrate), // I don't think this has any effect.
                .init(name: "directStreamAudio", value: true),
                .init(name: "mediaBufferSize", value: mediaBufferSize),
                .init(name: "session", value: UUID().uuidString), // Always(?) create a new transcode session.
                .init(name: "protocol", value: `protocol`),
                .init(name: "directPlay", value: false),
                .init(name: "hasMDE", value: true),
            ]

            items.append(
                // swiftlint:disable line_length
                .init(name: "X-Plex-Client-Profile-Extra", value: """
                add-transcode-target(type=musicProfile&context=streaming&protocol=\(`protocol`)&container=mpegts&audioCodec=\(audioCodec))
                +add-limitation(scope=musicCodec&scopeName=\(audioCodec)&type=upperBound&name=audio.bitrate&value=\(preferredBitrate)&replace=true)
                """)
                // swiftlint:enable line_length
            )

            // Add client info as URL params.
            for (key, value) in clientInfo.asMap() {
                items.append(URLQueryItem(name: key.rawValue, value: value))
            }

            return items
        }

        /// The id of the track.
        /// - SeeAlso: `ratingKey` property of `MediaItem.Part`.
        private let ratingKey: String

        /// The playback session ID.
        /// This is used by the server to relate a transcode session to the timeline item.
        /// - SeeAlso: `session` property of `Timeline` request.
        private let session: UUID

        /// - Warning: This value is not always respected by the server.
        private let preferredBitrate: Int

        /// Known supported values: 'mp3', 'aac'.
        private let audioCodec: String

        /// Default value taken from plex web.
        private let mediaBufferSize: Int

        /// The streaming protocol to use. Known supported values: `hls`, `dash`.
        /// - Warning: Everything other than 'hls' has not been tested.
        private let `protocol` = "hls"

        /// Client info to add as URL parameters.
        private let clientInfo: Plex.ClientInfo

        public init(
            ratingKey: String,
            session: UUID,
            preferredBitrate: Int,
            audioCodec: String = "mp3",
            mediaBufferSize: Int = 12288,
            clientInfo: Plex.ClientInfo
        ) {
            self.ratingKey = ratingKey
            self.session = session
            self.preferredBitrate = preferredBitrate
            self.audioCodec = audioCodec
            self.mediaBufferSize = mediaBufferSize
            self.clientInfo = clientInfo
        }

        public func asURLRequest(from url: URL) throws -> URLRequest {
            guard let token = clientInfo.token else {
                throw PlexError.notAuthenticated
            }
            return try asURLRequest(from: url, using: token)
        }

        public static func response(from data: Data) throws -> Data {
            data
        }

        /// The HLS index (m3u8), left for the client to decode.
        public typealias Response = Data
    }
}
