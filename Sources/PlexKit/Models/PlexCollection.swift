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
    public let childCount: Int?
    public let maxYear: String?
    public let minYear: String?
    private let smart: String?

    public var isSmart: Bool { smart == "1" }

    private enum CodingKeys: String, CodingKey {
        case key
        case title
        case titleSort
        case ratingKey
        case guid
        case type
        case subtype
        case summary
        case index
        case ratingCount
        case thumb
        case addedAt
        case updatedAt
        case childCount
        case maxYear
        case minYear
        case smart
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        key = try container.decode(String.self, forKey: .key)
        title = try container.decode(String.self, forKey: .title)

        titleSort = try container.decodeIfPresent(String.self, forKey: .titleSort)
        ratingKey = try container.decodeIfPresent(String.self, forKey: .ratingKey)
        guid = try container.decodeIfPresent(String.self, forKey: .guid)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        subtype = try container.decodeIfPresent(PlexMediaType.self, forKey: .subtype)
        summary = try container.decodeIfPresent(String.self, forKey: .summary)
        index = try container.decodeIfPresent(Int.self, forKey: .index)
        ratingCount = try container.decodeIfPresent(Int.self, forKey: .ratingCount)
        thumb = try container.decodeIfPresent(String.self, forKey: .thumb)
        addedAt = try container.decodeIfPresent(Date.self, forKey: .addedAt)
        updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        maxYear = try container.decodeIfPresent(String.self, forKey: .maxYear)
        minYear = try container.decodeIfPresent(String.self, forKey: .minYear)
        smart = try container.decodeIfPresent(String.self, forKey: .smart)

        // As of PMS 1.41.2, `childCount` is an int, not a string.
        if let intValue = try? container.decode(Int.self, forKey: .childCount) {
            childCount = intValue
        } else if let stringValue = try? container.decode(String.self, forKey: .childCount) {
            childCount = Int(stringValue)
        } else {
            childCount = nil
        }
    }
}
