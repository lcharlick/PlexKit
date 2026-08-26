//
//  PlexPlaylistType.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 1/6/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

public enum PlexPlaylistType: String, Codable, Sendable {
    case audio
    case video
    /// - Warning: Not tested.
    case photo
}
