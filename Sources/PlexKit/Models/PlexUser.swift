//
//  PlexUser.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 31/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

public struct PlexUser: Codable {
    public let id: Int
    public let uuid: String
    public let email: String?
    public let joinedAt: Date?
    public let username: String?
    public let title: String
    public let thumb: String?
    public let hasPassword: Bool
    public let authToken: String?
    public let authenticationToken: String?
    public let subscription: Subscription?
    public let entitlements: [String]?
    public let confirmedAt: Date?
    public let forumID: Int?
    public let ssoCookie: Bool?
    public let rememberMe: Bool?
    public let restricted: Bool?
    public let home: Bool?
    public let admin: Bool?
    public let guest: Bool?
    public let protected: Bool?

    /* `Roles` data is different depending on the route used,
      * so I've removed it for now.
     public let roles: Roles?
     public struct Roles: Codable {
         public let roles: [String]
     }
     */

    public struct Subscription: Codable {
        public let active: Bool
        public let status: String
        public let plan: String?
        public let features: [String]
    }
}
