//
//  Resources.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 29/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

public extension Plex.ServiceRequest {
    struct Resources: PlexServiceRequest {
        public let path = "api/v2/resources"

        public var queryItems: [URLQueryItem]? {
            [
                URLQueryItem(name: "includeHttps", value: preferSecureConnections),
                URLQueryItem(name: "includeRelay", value: includeRelayConnections),
            ]
        }

        private let preferSecureConnections: Bool
        private let includeRelayConnections: Bool

        public init(
            preferSecureConnections: Bool = true,
            includeRelayConnections: Bool = true
        ) {
            self.preferSecureConnections = preferSecureConnections
            self.includeRelayConnections = includeRelayConnections
        }

        public static func response(from data: Data) throws -> [PlexResource] {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([PlexResource].self, from: data)
        }
    }
}
