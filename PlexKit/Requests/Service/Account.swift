//
//  Account.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 31/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

public extension Plex.ServiceRequest {
    struct Account: PlexServiceRequest {
        public let path = "users/account.json"
        public let httpMethod = "GET"

        public init() {}

        public static func response(from data: Data) throws -> Response {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(Response.self, from: data)
        }

        public struct Response: Codable {
            public let user: PlexUser
        }
    }
}
