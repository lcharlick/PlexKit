//
//  SimpleAuthentication.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 30/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

public extension Plex.ServiceRequest {
    struct SimpleAuthentication: PlexServiceRequest {
        public let path = "users/sign_in.json"
        public let httpMethod = "POST"

        public var queryItems: [URLQueryItem]? {
            [
                URLQueryItem(name: "user[login]", value: username),
                URLQueryItem(name: "user[password]", value: password),
            ]
        }

        private let username: String
        private let password: String

        public init(username: String, password: String) {
            self.username = username
            self.password = password
        }

        public static func response(from data: Data) throws -> Response {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Response.self, from: data)
        }

        public struct Response: Codable {
            public let user: PlexUser
        }
    }
}
