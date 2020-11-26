//
//  Playlists.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 1/6/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

public extension Plex.Request {
    struct Playlists: PlexResourceRequest {
        public var path: String {
            switch action {
            case .delete(let ratingKey):
                return "playlists/\(ratingKey)"
            case .addItems(let ratingKey, _, _):
                return "playlists/\(ratingKey)/items"
            case .removeItem(ratingKey: let ratingKey, itemRatingKey: let itemRatingKey):
                return "playlists/\(ratingKey)/items/\(itemRatingKey)"
            default:
                return "playlists"
            }
        }

        public var httpMethod: String {
            switch action {
            case .get:
                return "GET"
            case .create:
                return "POST"
            case .delete, .removeItem:
                return "DELETE"
            case .addItems:
                return "PUT"
            }
        }

        /// The action to perform against the playlist.
        private let action: Action

        private func queryItemForItemRatingKeys(_ ratingKeys: [String], resource: String) -> URLQueryItem {
            let keys = ratingKeys.joined(separator: ",")
            return URLQueryItem(
                name: "uri",
                value: "server://\(resource)/com.plexapp.plugins.library/library/metadata/\(keys)"
            )
        }

        public var queryItems: [URLQueryItem]? {
            var items: [URLQueryItem] = []

            switch action {
            case .get(type: let type, libraryKey: let libraryKey, smart: let smart):
                items.append(.init(name: "playlistType", value: type.rawValue))

                if let libraryKey = libraryKey {
                    items.append(
                        .init(name: "sectionID", value: libraryKey)
                    )
                }

                if let smart = smart {
                    items.append(
                        .init(name: "smart", value: smart))
                }
            case .create(
                    title: let title,
                    type: let type,
                    resource: let resource,
                    itemRatingKeys: let itemRatingKeys
            ):
                items.append(contentsOf: [
                    .init(name: "type", value: type.rawValue),
                    .init(name: "title", value: title),
                    queryItemForItemRatingKeys(itemRatingKeys, resource: resource)
                ])
            case .addItems(_, let resource, let itemRatingKeys):
                items.append(queryItemForItemRatingKeys(itemRatingKeys, resource: resource))
            case .delete, .removeItem:
                break
            }

            return items
        }

        public init(
            action: Action
        ) throws {
            self.action = action
            switch action {
            case .create(_, _, _, let ratingKeys) where ratingKeys.isEmpty:
                throw InvalidRequest.noItems
            default:
                break
            }
        }

        public init(
            type: PlexPlaylistType,
            smart: Bool? = nil,
            libraryKey: Int? = nil
        ) {
            // `get` action cannot throw.
            try! self.init(
                action: .get(type: type, libraryKey: libraryKey, smart: smart)
            )
        }

        public static func response(from data: Data) throws -> Response {
            data.isEmpty
                // DELETE requests send an empty response, which causes a decode error to be thrown.
                // Instead, construct and return a response with an empty `MediaContainer`.
                ? Response(mediaContainer: .empty)
                : try _response(from: data)
        }

        public struct Response: Codable {
            public let mediaContainer: MediaContainer

            enum CodingKeys: String, CodingKey {
                case mediaContainer = "MediaContainer"
            }
        }
    }
}

public extension Plex.Request.Playlists {
    struct MediaContainer: Codable {
        init(
            size: Int,
            totalSize: Int?,
            offset: Int?,
            Metadata: [PlexMediaItem]?
        ) {
            self.size = size
            self.totalSize = totalSize
            self.offset = offset
            self.Metadata = Metadata
        }

        /// An empty media container.
        static var empty: Self {
            .init(size: 0, totalSize: 0, offset: 0, Metadata: nil)
        }

        let size: Int
        let totalSize: Int?
        let offset: Int?

        let Metadata: [PlexMediaItem]?

        public var metadata: [PlexMediaItem] {
            self.Metadata ?? []
        }
    }

    enum Action {
        /// Fetch playlists.
        case get(
            type: PlexPlaylistType,
            libraryKey: Int?,
            smart: Bool?
         )

        /// Create a new playlist.
        case create(
            title: String,
            type: PlexPlaylistType,
            resource: String,
            itemRatingKeys: [String]
         )

        /// Delete a playlist.
        case delete(ratingKey: String)

        /// Add items to a playlist.
        case addItems(
            ratingKey: String,
            resource: String,
            itemRatingKeys: [String]
         )

        /// Remove an item from a playlist.
        case removeItem(
            ratingKey: String,
            itemRatingKey: String
         )
    }

    enum InvalidRequest: Error {
        /// Item list is empty.
        case noItems
    }
}
