//
//  CollectionItems.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 18/10/21.
//  Copyright © 2021 Lachlan Charlick. All rights reserved.
//

import Foundation

public extension Plex.Request {
    /// Requires Plex Media Server 1.22.3.4392.
    typealias CollectionItems = _CollectionItems<PlexMediaItem>

    struct _CollectionItems<MediaItem: PlexMediaItemType>: PlexResourceRequest {
        public var path: String { "library/collections/\(ratingKey)/children" }
        private let ratingKey: String

        public init(ratingKey: String) {
            self.ratingKey = ratingKey
        }

        public struct Response: Codable {
            public let mediaContainer: MediaContainer

            enum CodingKeys: String, CodingKey {
                case mediaContainer = "MediaContainer"
            }
        }
    }
}

public extension Plex.Request._CollectionItems {
    struct MediaContainer: Codable {
        public let size: Int
        public let totalSize: Int?
        public let offset: Int?
        private let Metadata: [MediaItem]?

        public var metadata: [MediaItem] {
            Metadata ?? []
        }
    }
}
