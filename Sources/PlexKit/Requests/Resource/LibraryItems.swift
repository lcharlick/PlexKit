//
//  LibraryItems.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 31/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

public extension Plex.Request {
    /// Fetches a library's contents.
    struct LibraryItems: PlexResourceRequest {
        public var path: String { "library/sections/\(key)/all" }
        public var queryItems: [URLQueryItem]? {
            var items: [URLQueryItem] = [
                URLQueryItem(name: "type", value: mediaType.key)
            ]

            if let range = range, let start = range.first, let end = range.last {
                items.append(contentsOf: [
                    URLQueryItem(name: "X-Plex-Container-Start", value: start),
                    URLQueryItem(name: "X-Plex-Container-Size", value: end - start)
                ])
            }

            for filter in filters {
                guard let queryItem = filter.queryItem else { continue }
                items.append(queryItem)
            }

            let excludeFields = [
                // This field can contain invalid unicode characters, causing
                // JSON decode errors. We don't use the field currently, so it can
                // be explicitly excluded here.
                "file"
            ] + self.excludeFields

            items.append(
                URLQueryItem(
                    name: "excludeFields",
                    value: excludeFields.joined(separator: ",")
                )
            )

            return items
        }

        var key: PlexLibrary.Key
        var mediaType: PlexMediaType
        var range: CountableClosedRange<Int>?
        var excludeFields: [String] = []
        var filters: [Filter] = []

        public init(
            key: PlexLibrary.Key,
            mediaType: PlexMediaType,
            range: CountableClosedRange<Int>? = nil,
            excludeFields: [String] = [],
            filters: [Filter] = []
        ) {
            self.key = key
            self.mediaType = mediaType
            self.range = range
            self.excludeFields = excludeFields
            self.filters = filters
        }

        public struct Response: Codable {
            public let mediaContainer: MediaContainer
        }
    }
}

public extension Plex.Request.LibraryItems {
    /// Filters the results of a `LibraryItems` request.
    enum Filter {
        /// Requests items in a specific set.
        case keys(Set<String>)

        /// Filters by a field in the result type.
        case property(name: String, Comparison, String)

        /// Filters by a date field in the result type.
        case dateProperty(name: String, Comparison, Date)

        /// Filters by items in a given collection.
        case collection(id: String)

        fileprivate var queryItem: URLQueryItem? {
            switch self {
            case .keys(let keys):
                guard !keys.isEmpty else { return nil }
                return .init(name: "id", value: keys.joined(separator: ","))
            case .property(let name, let comparison, let value):
                return .init(name: name+comparison.rawValue, value: value)
            case .dateProperty(let name, let comparison, let value):
                return .init(name: name+comparison.rawValue, value: String(Int(value.timeIntervalSince1970)))
            case .collection(let id):
                return .init(name: "collection", value: id)
            }
        }

        public enum Comparison: String {
            case greaterThan = ">"
            case lessThan = "<"
            case equal = ""
        }
    }
}

public extension Plex.Request.LibraryItems.Response {
    enum CodingKeys: String, CodingKey {
        case mediaContainer = "MediaContainer"
    }

    struct MediaContainer: Codable, Hashable {
        public let size: Int
        public let totalSize: Int?
        public let allowSync: Bool?
        public let art: String?
        public let identifier: String?
        public let librarySectionID: PlexLibrary.Id?
        public let librarySectionTitle: String?
        public let librarySectionUUID: PlexLibrary.UUID?
        public let mediaTagPrefix: String?
        public let mediaTagVersion: Int?
        public let nocache: Bool?
        public let offset: Int?
        public let thumb: String?
        public let title1: String?
        public let title2: String?
        public let viewGroup: PlexMediaType?
        public let viewMode: Int?

        private let Metadata: [PlexMediaItem]?

        public var metadata: [PlexMediaItem] {
            self.Metadata ?? []
        }
    }
}
