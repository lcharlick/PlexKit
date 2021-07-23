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
    struct PlaylistItems: PlexResourceRequest {
        public var path: String {
            let path = "playlists/\(ratingKey)/items"
            switch action {
            case .remove(let ratingKey):
                return "\(path)/\(ratingKey)"
            case .move(let ratingKey, _):
                return "\(path)/\(ratingKey)/move"
            default:
                return path
            }
        }

        public var queryItems: [URLQueryItem]? {
            switch action {
            case .add(let resource, let ratingKeys):
                return [
                    uriForResource(resource, itemRatingKeys: ratingKeys)
                ]
            case .move(_, let afterRatingKey) where afterRatingKey != nil:
                return [
                    .init(
                        name: "after",
                        value: afterRatingKey!.rawValue
                    )
                ]
            default:
                return nil
            }
        }

        public var httpMethod: String {
            switch action {
            case .get:
                return "GET"
            case .add, .move:
                return "PUT"
            case .remove:
                return "DELETE"
            }
        }

        private let action: Action
        private let ratingKey: PlexMediaItem.RatingKey

        public init(
            ratingKey: PlexMediaItem.RatingKey,
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

        public enum Action {
            /// Get the items in the playlist.
            case get
            /// Add one or more items to the playlist.
            case add(resource: PlexResource.Id, ratingKeys: [PlexMediaItem.RatingKey])
            /// Remove an item from the playlist.
            case remove(ratingKey: PlexMediaItem.RatingKey)
            /// Move the position of an item in the playlist.
            /// Use `nil` as `after` value to move the item to the beginning of the playlist.
            case move(ratingKey: PlexMediaItem.RatingKey, after: PlexMediaItem.RatingKey?)
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
