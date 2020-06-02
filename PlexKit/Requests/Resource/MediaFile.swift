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
            token.map {
                [.init(name: Plex.Header.token.rawValue, value: $0)]
            }
        }

        private let token: String?

        public init(path: String, token: String? = nil) {
            self.path = path
            self.token = token
        }

        public func asURLRequest(from url: URL) throws -> URLRequest {
            guard let token = token else {
                throw PlexError.notAuthenticated
            }
            return try self.asURLRequest(from: url, using: token)
        }

        public static func response(from data: Data) throws -> Data {
            data
        }
    }
}
