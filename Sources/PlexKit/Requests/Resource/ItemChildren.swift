//
//  ItemMetadata.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 1/6/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

public extension Plex.Request {
    /// Fetch metadata for a `PlexMediaItem`.
    /// - Warning: not tested.
    struct ItemChildren: PlexResourceRequest {
        public var path: String { "library/metadata/\(ratingKey)/children" }

        public var queryItems: [URLQueryItem]? {
            [
                .init(name: "excludeAllLeaves", value: excludeAllLeaves),
            ]
        }

        /// - SeeAlso: `ratingKey` property of `MediaItem`.
        private let ratingKey: String

        private let excludeAllLeaves: Bool

        public init(
            ratingKey: String,
            excludeAllLeaves: Bool = true
        ) {
            self.ratingKey = ratingKey
            self.excludeAllLeaves = excludeAllLeaves
        }

        public struct Response: Codable {
            public let mediaContainer: MediaContainer
        }
    }
}

public extension Plex.Request.ItemChildren.Response {
    enum CodingKeys: String, CodingKey {
        case mediaContainer = "MediaContainer"
    }

    struct MediaContainer: Codable {
        public let size: Int
        public let allowSync: Bool?
        public let augmentationKey: String?
        public let identifier: String?
        public let librarySectionID: Int?
        public let librarySectionTitle: String?
        public let librarySectionUUID: String?
        public let mediaTagPrefix: String?
        public let mediaTagVersion: Int?

        private let Metadata: [PlexMediaItem]?

        public var metadata: [PlexMediaItem] {
            self.Metadata ?? []
        }
    }
}
