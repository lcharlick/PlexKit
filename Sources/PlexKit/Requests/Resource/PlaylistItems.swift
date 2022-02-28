//
//  PlaylistItems.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 1/6/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

public extension Plex.Request {
    /// Perform an action on a playlist's contents.
    typealias PlaylistItems = _PlaylistItems<PlexMediaItem>

    struct _PlaylistItems<MediaItem: PlexMediaItemType>: PlexResourceRequest {
        public var path: String {
            let path = "playlists/\(ratingKey)/items"
            switch action {
            case let .remove(ratingKey):
                return "\(path)/\(ratingKey)"
            case let .move(ratingKey, _):
                return "\(path)/\(ratingKey)/move"
            default:
                return path
            }
        }

        public var queryItems: [URLQueryItem]? {
            switch action {
            case let .add(resource, ratingKeys):
                return [
                    uriForResource(resource, itemRatingKeys: ratingKeys),
                ]
            case let .move(_, afterRatingKey) where afterRatingKey != nil:
                return [
                    .init(
                        name: "after",
                        value: afterRatingKey
                    ),
                ]
            case let .getRange(range):
                return pageQueryItems(for: range)
            default:
                return nil
            }
        }

        public var httpMethod: String {
            switch action {
            case .get, .getRange:
                return "GET"
            case .add, .move:
                return "PUT"
            case .remove:
                return "DELETE"
            }
        }

        private let action: Action

        /// - SeeAlso: `ratingKey` property of `MediaItem`.
        private let ratingKey: String

        public init(
            ratingKey: String,
            action: Action = .get
        ) {
            self.ratingKey = ratingKey
            self.action = action
        }

        public struct Response: Codable {
            public let mediaContainer: MediaContainer

            enum CodingKeys: String, CodingKey {
                case mediaContainer = "MediaContainer"
            }
        }

        public struct MediaContainer: Codable {
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

            private let Metadata: [MediaItem]?

            public var metadata: [MediaItem] {
                Metadata ?? []
            }
        }

        public enum Action {
            /// Get the items in the playlist.
            case get
            /// Get paged items in the playlist.
            case getRange(CountableClosedRange<Int>)
            /// Add one or more items to the playlist.
            case add(resource: String, ratingKeys: [String])
            /// Remove an item from the playlist.
            case remove(ratingKey: String)
            /// Move the position of an item in the playlist.
            /// Use `nil` as `after` value to move the item to the beginning of the playlist.
            case move(ratingKey: String, after: String?)
        }
    }
}
