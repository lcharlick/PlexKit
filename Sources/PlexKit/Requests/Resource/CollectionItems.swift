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

        public var queryItems: [URLQueryItem]? {
            var items: [URLQueryItem] = []
            if let start = containerStart {
                items.append(URLQueryItem(name: "X-Plex-Container-Start", value: start))
            }
            if let size = containerSize {
                items.append(URLQueryItem(name: "X-Plex-Container-Size", value: size))
            }
            return items.isEmpty ? nil : items
        }

        private let ratingKey: String
        private let containerStart: Int?
        private let containerSize: Int?

        public init(
            ratingKey: String,
            containerStart: Int? = nil,
            containerSize: Int? = nil
        ) {
            self.ratingKey = ratingKey
            self.containerStart = containerStart
            self.containerSize = containerSize
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
