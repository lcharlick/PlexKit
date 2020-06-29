//
//  PlexLibrary.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 31/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

public struct PlexLibrary: Codable {
    public let key: String
    public let uuid: String
    public let type: PlexMediaType
    public let allowSync: Bool?
    public let art: String?
    public let composite: String?
    public let filters: Bool?
    public let refreshing: Bool?
    public let thumb: String?
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
