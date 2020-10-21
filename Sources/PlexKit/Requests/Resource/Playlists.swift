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
        public var path: String { "playlists" }

        private let type: PlexPlaylistType
        /// - SeeAlso: `key` property of `PlexLibrary`.
        private let libraryKey: Int?
        private let filter: Filter?

        public var queryItems: [URLQueryItem]? {
            var items: [URLQueryItem] = [
                .init(name: "playlistType", value: type.rawValue)
            ]

            if let libraryKey = libraryKey {
                items.append(
                    .init(name: "sectionID", value: libraryKey)
                )
            }

            if let filter = filter {
                items.append(
                    .init(name: "smart", value: filter == .smart))
            }

            return items
        }

        public init(
            type: PlexPlaylistType,
            libraryKey: Int? = nil,
            filter: Filter? = nil
        ) {
            self.type = type
            self.libraryKey = libraryKey
            self.filter = filter
        }

        public enum Filter: Equatable {
            /// Fetch only regular (i.e. non-smart) playlists.
            case regular
            /// Fetch only smart playlists.
            case smart
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
}
