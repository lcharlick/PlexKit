//
//  PlexCollection.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 1/6/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

public struct PlexCollection: Codable, Hashable {
    public let key: String
    public let title: String

    public let titleSort: String?
    public let ratingKey: String?
    public let guid: String?
    public let type: String?
    public let subtype: PlexMediaType?
    public let summary: String?
    public let index: Int?
    public let ratingCount: Int?
    public let thumb: String?
    public let addedAt: Date?
    public let updatedAt: Date?
    public let childCount: String?
    public let maxYear: String?
    public let minYear: String?
    private let smart: String?

    public var isSmart: Bool { smart == "1" }
}
