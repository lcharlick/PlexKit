//
//  RelatedMedia.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 31/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

public extension Plex.Request {
    typealias RelatedMedia = _RelatedMedia<PlexMediaItem>

    struct _RelatedMedia<MediaItem: PlexMediaItemType>: PlexResourceRequest {
        public var path: String { "/hubs/metadata/\(ratingKey)/related" }

        /// - SeeAlso: `ratingKey` property of `MediaItem`.
        private let ratingKey: String
        private let excludeFields: [String]

        public init(
            ratingKey: String,
            excludeFields: [String] = []
        ) {
            self.ratingKey = ratingKey
            self.excludeFields = excludeFields
        }

        public struct Response: Codable {
            public let mediaContainer: MediaContainer
        }
    }
}

public extension Plex.Request._RelatedMedia.Response {
    enum CodingKeys: String, CodingKey {
        case mediaContainer = "MediaContainer"
    }

    struct MediaContainer: Codable {
        public let size: Int
        public let totalSize: Int?
        public let allowSync: Bool?
        public let identifier: String?
        public let librarySectionID: Int?
        public let librarySectionTitle: String?
        public let librarySectionUUID: String?
        private let Hub: [Hub]?
        public var hubs: [Hub] {
            Hub ?? []
        }
    }

    struct Hub: Codable {
        public let size: Int
        public let hubKey: String?
        public let key: String
        public let title: String?
        public let type: PlexMediaType?
        public let hubIdentifier: String?
        public let context: String?
        public let more: Bool?
        public let style: String?
        private let Metadata: [MediaItem]?
        public var metadata: [MediaItem] {
            Metadata ?? []
        }
    }
}
