//
//  HomeUsers.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 31/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

public extension Plex.ServiceRequest {
    struct HomeUsers: PlexServiceRequest {
        public let path = "api/v2/home/users"
        public let httpMethod = "GET"

        public init() {}

        public struct Response: Codable {
            public let id: Int?
            public let name: String?
            public let guestUserID: Int?
            public let guestUserUUID: String?
            public let guestEnabled: Bool?
            public let subscription: Bool?
            public let users: [PlexUser]?
        }
    }
}
