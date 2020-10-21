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
            case .delete:
                return "DELETE"
            }
        }

        /// The media type of the contained items.
        private let type: PlexPlaylistType

        /// - SeeAlso: `key` property of `PlexLibrary`.
        private let libraryKey: String?

        /// The action to perform against the playlist.
        private let action: Action

        /// Whether the playlist is a smart (rule-based) playlist.
        private let smart: Bool?

        public var queryItems: [URLQueryItem]? {
            var items: [URLQueryItem] = [
                .init(name: "playlistType", value: type.rawValue)
            ]

            if let libraryKey = libraryKey {
                items.append(
                    .init(name: "sectionID", value: libraryKey)
                )
            }

            if let smart = smart {
                items.append(
                    .init(name: "smart", value: smart))
            }

            switch action {
            case .create(let title, let libraryUUID, let ratingKeys):
                let keys = ratingKeys.joined(separator: ",")
                items.append(contentsOf: [
                    .init(name: "title", value: title),
                    .init(name: "uri", value: "library://\(libraryUUID)/directory//library/metadata/\(keys)")
                ])
            default:
                break
            }

            return items
        }

        public init(
            action: Action = .get,
            type: PlexPlaylistType,
            libraryKey: String? = nil,
            smart: Bool? = nil
        ) throws {
            self.action = action
            self.type = type
            self.libraryKey = libraryKey
            self.smart = smart

            switch action {
            case .create(_, _, let ratingKeys) where ratingKeys.isEmpty:
                throw InvalidRequest.noItems
            default:
                break
            }
        }

        public init(
            type: PlexPlaylistType,
            libraryKey: String? = nil,
            smart: Bool? = nil
        ) {
            // `get` action cannot throw.
            try! self.init(
                action: .get,
                type: type,
                libraryKey: libraryKey,
                smart: smart
            )
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
        let size: Int
        let totalSize: Int?
        let offset: Int?

        private let Metadata: [PlexMediaItem]?

        public var metadata: [PlexMediaItem] {
            self.Metadata ?? []
        }
    }

    enum Action {
        case get
        case create(
            title: String,
            libraryUUID: String,
            ratingKeys: [String]
         )
        case delete(ratingKey: String)
    }

    enum InvalidRequest: Error {
        /// Item list is empty.
        case noItems
    }
}
