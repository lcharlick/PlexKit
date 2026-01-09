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
    
    #if DEBUG
    public init(
        id: Int,
        uuid: String,
        email: String? = nil,
        joinedAt: Date? = nil,
        username: String? = nil,
        title: String,
        thumb: String? = nil,
        hasPassword: Bool,
        authToken: String? = nil,
        authenticationToken: String? = nil,
        entitlements: [String]? = nil,
        confirmedAt: Date? = nil,
        forumID: Int? = nil,
        ssoCookie: Bool? = nil,
        rememberMe: Bool? = nil,
        restricted: Bool? = nil,
        home: Bool? = nil,
        admin: Bool? = nil,
        guest: Bool? = nil,
        protected: Bool? = nil
    ) {
        self.id = id
        self.uuid = uuid
        self.email = email
        self.joinedAt = joinedAt
        self.username = username
        self.title = title
        self.thumb = thumb
        self.hasPassword = hasPassword
        self.authToken = authToken
        self.authenticationToken = authenticationToken
        self.entitlements = entitlements
        self.confirmedAt = confirmedAt
        self.forumID = forumID
        self.ssoCookie = ssoCookie
        self.rememberMe = rememberMe
        self.restricted = restricted
        self.home = home
        self.admin = admin
        self.guest = guest
        self.protected = protected
    }
    #endif

    /* Data is different depending on the route used, so I've removed these for now.
         public let roles: Roles?
         public struct Roles: Codable {
         public let roles: [String]
     }
     
     public let subscription: Subscription?
     public struct Subscription: Codable {
         let state: String?
         let type: String?
     }
     */
}
