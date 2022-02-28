//
//  MediaFile.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 31/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

public extension Plex.Request {
    struct MediaFile: PlexResourceRequest {
        /// The path to the media file.
        /// - SeeAlso: `key` property of `MediaItem.Part`.
        public let path: String
        public let accept = "*/*"
        public var queryItems: [URLQueryItem]? {
            [
                token.map { .init(name: Plex.Header.token.rawValue, value: $0) },
                .init(name: "download", value: download),
                .init(name: "stripTags", value: stripTags),
            ].compactMap { $0 }
        }

        /// A token value to use in the URL query. Useful for when the session token can't be used.
        private let token: String?

        /// When `false`, Plex will terminate any existing media streams using the same `X-Plex-Client-Identifier`.
        private let download: Bool

        /// When `true`, Plex will strip most embedded tags from some file formats.
        private let stripTags: Bool

        /// Creates an instance.
        /// - Parameters:
        ///   - path: The path to the media file.
        ///   - token: A token value to use in the URL query. Useful for when the session token can't be used.
        ///   - download: When `false`, Plex will terminate any existing media streams using the same `X-Plex-Client-Identifier`.
        ///   - stripTags: When `true`, Plex will strip most embedded tags from some file formats.
        public init(
            path: String,
            token: String? = nil,
            download: Bool = false,
            stripTags: Bool = true
        ) {
            self.path = path
            self.token = token
            self.download = download
            self.stripTags = stripTags
        }

        public func asURLRequest(from url: URL) throws -> URLRequest {
            guard let token = token else {
                throw PlexError.notAuthenticated
            }
            return try _asURLRequest(from: url, using: token)
        }

        public static func response(from data: Data) throws -> Data {
            data
        }
    }
}
