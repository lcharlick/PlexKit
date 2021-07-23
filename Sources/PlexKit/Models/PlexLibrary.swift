//
//  PlexLibrary.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 31/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation
import Tagged

public struct PlexLibrary: Codable {
    public typealias Id = Tagged<PlexLibrary, Int>
    public typealias Key = Tagged<(PlexLibrary, key: ()), String>
    public typealias UUID = Tagged<(PlexLibrary, uuid: ()), String>

    public let key: Key
    public var id: Id? {
        Int(key.rawValue).map(Id.init(rawValue:))
    }

    public let uuid: UUID
    public let type: PlexMediaType
    public let allowSync: Bool?
    public let art: Plex.ImagePath?
    public let composite: Plex.ImagePath?
    public let filters: Bool?
    public let refreshing: Bool?
    public let thumb: Plex.ImagePath?
    public let title: String?
    public let agent: String?
    public let scanner: String?
    public let language: String?
    public let updatedAt: Date?
    public let createdAt: Date?
    public let scannedAt: Date?
    private let Location: [Location]?

    public var locations: [Location]? {
        self.Location
    }

    public struct Location: Codable {
        public let id: Int
        public let path: String
    }
}
