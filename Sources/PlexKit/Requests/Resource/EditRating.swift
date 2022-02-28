//
//  EditRating.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 31/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

public extension Plex.Request {
    struct EditRating: PlexResourceRequest {
        public let path = ":/rate"
        public let httpMethod = "PUT"
        public var accept = "*/*"

        public var queryItems: [URLQueryItem]? {
            [
                .init(name: "key", value: ratingKey),
                .init(name: "rating", value: rating),
                .init(name: "identifier", value: "com.plexapp.plugins.library"),
            ]
        }

        /// - SeeAlso: `ratingKey` property of `MediaItem`.
        private let ratingKey: String
        private let rating: Int

        public init(ratingKey: String, rating: Int) {
            self.ratingKey = ratingKey
            self.rating = rating.clamped(to: 0 ... 10)
        }

        public static func response(from data: Data) throws -> Data {
            // Empty response.
            data
        }
    }
}
