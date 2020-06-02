//
//  PlexMediaType.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 27/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

/// - Note: https://github.com/Arcanemagus/plex-api/wiki/MediaTypes
public enum PlexMediaType: String, Codable {
    case movie
    case show
    case season
    case episode
    case trailer
    case comic
    case person

    case artist
    case album
    case track
    case photoAlbum
    case picture
    case photo

    case playlist
    case playlistFolder
    case userPlaylistItem

    case collection
}

extension PlexMediaType {
    var key: Int {
        switch self {
        case .movie:
            return 1
        case .show:
            return 2
        case .season:
            return 3
        case .episode:
            return 4
        case .trailer:
            return 5
        case .comic:
            return 6
        case .person:
            return 7
        case .artist:
            return 8
        case .album:
            return 9
        case .track:
            return 10
        case .photoAlbum:
            return 11
        case .picture:
            return 12
        case .photo:
            return 13
        case .playlist:
            return 15
        case .playlistFolder:
            return 16
        case .collection:
            return 18
        case .userPlaylistItem:
            return 1001
        }
    }
}
