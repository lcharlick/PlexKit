//
//  Timeline.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 31/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

public extension Plex.Request {
    /// Update the plex playback timeline.
    struct Timeline: PlexResourceRequest {
        public let path = ":/timeline"
        public let accept = "application/xml"

        public var queryItems: [URLQueryItem]? {
            [
                .init(name: Plex.Header.sessionIdentifier.rawValue, value: session.uuidString),
                .init(name: "ratingKey", value: ratingKey),
                .init(name: "key", value: "/library/metadata/\(ratingKey)"),
                .init(name: "state", value: state.rawValue),
                .init(name: "time", value: currentTime),
                .init(name: "duration", value: duration),
                .init(name: "continuing", value: isContinuing),
                .init(name: "hasMDE", value: true),
            ]
        }

        /// The playback session ID.
        /// This seems to be used by the server to relate a transcode session to the timeline item.
        private let session: UUID

        /// - SeeAlso: `ratingKey` property of `MediaItem`.
        /// - Warning: the `MediaItem` type must be playable.
        private let ratingKey: String

        /// The current playback state.
        private let state: State

        /// The current playback time, in milliseconds.
        private let currentTime: Int

        /// The duration of the currently playing item, in milliseconds.
        private let duration: Int

        /// 🤷‍♂️
        private let isContinuing: Bool

        public init(
            session: UUID,
            ratingKey: String,
            state: State,
            currentTime: Int,
            duration: Int,
            isContinuing: Bool
        ) {
            self.session = session
            self.ratingKey = ratingKey
            self.state = state
            self.currentTime = currentTime.clamped(to: 0 ... duration)
            self.duration = duration
            self.isContinuing = isContinuing
        }

        public static func response(from data: Data) throws -> Data {
            data
        }

        public enum State: String {
            case paused
            case playing
            case buffering
            case stopped
        }

        /// The response in XML format, left for the client to decode.
        public typealias Response = Data
    }
}
