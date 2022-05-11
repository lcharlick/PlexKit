//
// Created by Lachlan Charlick on 11/5/2022.
//

import Foundation

public extension Plex.Request {
    /// Fetches a folder's contents.
    struct Folder: PlexResourceRequest {
        public var path: String {
            "library/sections/\(key)/folder"
        }

        public var queryItems: [URLQueryItem]? {
            var items: [URLQueryItem] = [
                URLQueryItem(name: "type", value: mediaType.key),
            ]

            if let parentRatingKey = parentRatingKey {
                items.append(URLQueryItem(name: "parent", value: parentRatingKey))
            }

            if let range = range {
                items.append(contentsOf: pageQueryItems(for: range))
            }

            items.append(
                URLQueryItem(
                    name: "excludeFields",
                    value: excludeFields.joined(separator: ",")
                )
            )

            return items
        }

        var key: String
        var mediaType: PlexMediaType
        /// The ratingKey of the parent folder. When nil, fetch the root folder of the library.
        var parentRatingKey: String?
        var range: CountableClosedRange<Int>?
        var excludeFields: [String] = []

        public init(
            key: String,
            mediaType: PlexMediaType,
            parentRatingKey: String?,
            range: CountableClosedRange<Int>? = nil,
            excludeFields: [String] = [
                // This field can contain invalid unicode characters, causing
                // JSON decode errors. Exclude it by default.
                "file",
            ]
        ) {
            self.key = key
            self.mediaType = mediaType
            self.parentRatingKey = parentRatingKey
            self.range = range
            self.excludeFields = excludeFields
        }

        public struct Response: Codable {
            public let mediaContainer: MediaContainer
        }
    }
}

public extension Plex.Request.Folder.Response {
    enum CodingKeys: String, CodingKey {
        case mediaContainer = "MediaContainer"
    }

    struct MediaContainer: Codable, Hashable {
        public let size: Int
        public let totalSize: Int?
        public let allowSync: Bool?
        public let art: String?
        public let identifier: String?
        public let librarySectionID: Int?
        public let librarySectionTitle: String?
        public let librarySectionUUID: String?
        public let mediaTagPrefix: String?
        public let mediaTagVersion: Int?
        public let nocache: Bool?
        public let offset: Int?
        public let thumb: String?
        public let title1: String?
        public let title2: String?
        public let viewGroup: PlexMediaType?
        public let viewMode: Int?

        private let Metadata: [ItemType]?

        public var metadata: [ItemType] {
            Metadata ?? []
        }
    }

    enum ItemType: Codable, Hashable {
        case folder(PlexFolderItem)
        case mediaItem(PlexMediaItem)

        private enum CodingKeys: CodingKey {
            case ratingKey
            case key
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if try container.decodeIfPresent(String.self, forKey: .ratingKey) == nil {
                // If the item has no ratingKey, we can assume it's a folder.
                self = .folder(try PlexFolderItem(from: decoder))
            } else {
                self = .mediaItem(try PlexMediaItem(from: decoder))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .folder(let folder):
                try container.encode(folder)
            case .mediaItem(let mediaItem):
                try container.encode(mediaItem)
            }
        }
    }
}