//
//  OAuth.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 31/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

public extension Plex.ServiceRequest {
    /// Sign in using Plex's flavour of OAuth.
    /// Basic authentication flow:
    ///     - Perform this request initialized with no `id` parameter.
    ///     - Use the result of that request to initialize an authentication URL
    ///     (see `authenticationURL`).
    ///     - Redirect the user to the authentication URL.
    ///     - Initialize another request with an `id` from the initial response.
    ///     - Poll continuously until the response contains an `authToken` value.
    struct OAuth: PlexServiceRequest {
        public var path: String {
            let path = "api/v2/pins"
            if let id = id {
                return "\(path)/\(id)"
            } else {
                return path
            }
        }

        public var httpMethod: String {
            id == nil ? "POST" : "GET"
        }

        public var queryItems: [URLQueryItem]? {
            guard id == nil else { return nil }
            return [URLQueryItem(name: "strong", value: true)]
        }

        private let id: Int64?

        public init(id: Int64? = nil) {
            self.id = id
        }

        public init(response: Response) {
            id = response.id
        }

        /// Builds an authentication URL from an OAuth response.
        public static func authenticationURL(
            for response: Response,
            forwardUrl: URL? = nil
        ) -> URL {
            var urlString = "https://app.plex.tv/auth#?clientID=\(response.clientIdentifier)&code=\(response.code)"

            if let forwardUrl = forwardUrl,
               let encoded = forwardUrl.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) {
                urlString += "&forwardUrl=\(encoded)"
            }

            return URL(string: urlString)!
        }

        public static func response(from data: Data) throws -> Response {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(Response.self, from: data)
        }

        public struct Response: Codable {
            public let id: Int64
            public let clientIdentifier: String
            public let code: String
            public let product: String?
            public let trusted: Bool?
            public let expiresIn: Int?
            public let createdAt: Date?
            public let expiresAt: Date?
            public let authToken: String?
            public let newRegistration: Bool?
        }
    }
}
