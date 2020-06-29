//
//  PlaylistItems.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 1/6/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

public extension Plex.Request {
    /// Request all items in a playlist.
    struct PlaylistItems: PlexResourceRequest {
        public var path: String { "playlists/\(ratingKey)/items" }

        /// - SeeAlso: `ratingKey` property of `MediaItem`.
        private let ratingKey: String

        public init(
            ratingKey: String
        ) {
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

public extension Plex.Request.PlaylistItems {
    struct MediaContainer: Codable {
        public let size: Int
        public let totalSize: Int?
        public let allowSync: Bool?
        public let composite: String?
        public let duration: Int?
        public let leafCount: Int?
        public let offset: Int?
        public let playlistType: PlexPlaylistType?
        public let ratingKey: String?
        public let smart: Bool?
        public let title: String?

        private let Metadata: [PlexMediaItem]?

        public var metadata: [PlexMediaItem] {
            self.Metadata ?? []
        }
    }
}
