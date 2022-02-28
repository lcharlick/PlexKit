//
//  Collections.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 1/6/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

public extension Plex.Request {
    struct Collections: PlexResourceRequest {
        public var path: String { "library/sections/\(libraryKey)/collection" }

        private let libraryKey: String
        private let mediaType: PlexMediaType

        public var queryItems: [URLQueryItem]? {
            [.init(name: "type", value: mediaType.key)]
        }

        public init(
            libraryKey: String,
            mediaType: PlexMediaType
        ) {
            self.libraryKey = libraryKey
            self.mediaType = mediaType
        }

        public struct Response: Codable {
            public let mediaContainer: MediaContainer

            enum CodingKeys: String, CodingKey {
                case mediaContainer = "MediaContainer"
            }
        }
    }
}

public extension Plex.Request.Collections {
    struct MediaContainer: Codable {
        public let size: Int
        public let allowSync: Bool?
        public let art: String?
        public let content: String?
        public let identifier: String?
        public let mediaTagPrefix: String?
        public let mediaTagVersion: Int?
        public let nocache: Bool?
        public let thumb: String?
        public let title1: String?
        public let title2: String?
        public let viewGroup: String?
        public let viewMode: Int?
        private let Directory: [PlexCollection]?

        public var directory: [PlexCollection] {
            Directory ?? []
        }
    }
}
