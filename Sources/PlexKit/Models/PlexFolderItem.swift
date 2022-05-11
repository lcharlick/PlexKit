//
//  PlexFolderItem.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 11/5/22.
//  Copyright © 2022 Lachlan Charlick. All rights reserved.
//


import Foundation

/// Represents a filesystem folder containing other folders and media items.
public struct PlexFolderItem: Codable, Hashable {
    public let key: String
    public let title: String

    public var ratingKey: String? {
        let comps = URLComponents(string: key)
        return comps?.queryItems?.first(where: { $0.name == "parent" })?.value
    }
}
