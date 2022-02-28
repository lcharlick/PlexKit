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
    typealias ItemMetadata = _ItemMetadata<PlexMediaItem>

    struct _ItemMetadata<MediaItem: PlexMediaItemType>: PlexResourceRequest {
        public var path: String { "library/metadata/\(ratingKey)" }

        public var queryItems: [URLQueryItem]? {
            [
                .init(name: "includeConcerts", value: includeConcerts),
                .init(name: "includeExtras", value: includeExtras),
                .init(name: "includeOnDeck", value: includeOnDeck),
                .init(name: "includePopularLeaves", value: includePopularLeaves),
                .init(name: "includePreferences", value: includePreferences),
                .init(name: "includeChapters", value: includeChapters),
                .init(name: "includeStations", value: includeStations),
                .init(name: "includeExternalMedia", value: includeExternalMedia),
            ]
        }

        /// - SeeAlso: `ratingKey` property of `MediaItem`.
        private let ratingKey: String

        private let includeConcerts: Bool
        private let includeExtras: Bool
        private let includeOnDeck: Bool
        private let includePopularLeaves: Bool
        private let includePreferences: Bool
        private let includeChapters: Bool
        private let includeStations: Bool
        private let includeExternalMedia: Bool

        public init(
            ratingKey: String,
            includeConcerts: Bool = false,
            includeExtras: Bool = false,
            includeOnDeck: Bool = false,
            includePopularLeaves: Bool = false,
            includePreferences: Bool = false,
            includeChapters: Bool = false,
            includeStations: Bool = false,
            includeExternalMedia: Bool = false
        ) {
            self.ratingKey = ratingKey
            self.includeConcerts = includeConcerts
            self.includeExtras = includeExtras
            self.includeOnDeck = includeOnDeck
            self.includePopularLeaves = includePopularLeaves
            self.includePreferences = includePreferences
            self.includeChapters = includeChapters
            self.includeStations = includeStations
            self.includeExternalMedia = includeExternalMedia
        }

        public struct Response: Codable {
            public let mediaContainer: MediaContainer
        }
    }
}

public extension Plex.Request._ItemMetadata.Response {
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

        private let Metadata: [MediaItem]?

        public var metadata: [MediaItem] {
            Metadata ?? []
        }
    }
}
