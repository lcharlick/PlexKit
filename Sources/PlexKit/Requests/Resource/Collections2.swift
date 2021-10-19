//
//  Collections2.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 18/10/21.
//  Copyright © 2021 Lachlan Charlick. All rights reserved.
//

import Foundation

public extension Plex.Request {
    /// New collections endpoint. Supports smart collections.
    /// Requires Plex Media Server 1.22.3.4392.
    struct Collections2: PlexResourceRequest {
        public var path: String { "library/sections/\(libraryKey)/collections" }

        private let libraryKey: String
        private let mediaType: PlexMediaType

        public var queryItems: [URLQueryItem]? {
            [.init(name: "subtype", value: mediaType.key)]
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

public extension Plex.Request.Collections2 {
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
        private let Metadata: [PlexCollection]?

        public var metadata: [PlexCollection] {
            Metadata ?? []
        }
    }
}
