//
//  PlexMediaType.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 27/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

/// - Note: https://github.com/Arcanemagus/plex-api/wiki/MediaTypes
public enum PlexMediaType: Hashable {
    case unknown(String)

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

    init(rawValue: String) {
        switch RawValue(rawValue: rawValue) {
        case .movie:
            self = .movie
        case .show:
            self = .show
        case .season:
            self = .season
        case .episode:
            self = .episode
        case .trailer:
            self = .trailer
        case .comic:
            self = .comic
        case .person:
            self = .person
        case .artist:
            self = .artist
        case .album:
            self = .album
        case .track:
            self = .track
        case .photoAlbum:
            self = .photoAlbum
        case .picture:
            self = .picture
        case .photo:
            self = .photo
        case .playlist:
            self = .playlist
        case .playlistFolder:
            self = .playlistFolder
        case .userPlaylistItem:
            self = .userPlaylistItem
        case .collection:
            self = .collection
        default:
            self = .unknown(rawValue)
        }
    }

    public var rawValue: String {
        switch self {
        case let .unknown(rawValue):
            return rawValue
        case .movie:
            return RawValue.movie.rawValue
        case .show:
            return RawValue.show.rawValue
        case .season:
            return RawValue.season.rawValue
        case .episode:
            return RawValue.episode.rawValue
        case .trailer:
            return RawValue.trailer.rawValue
        case .comic:
            return RawValue.comic.rawValue
        case .person:
            return RawValue.person.rawValue
        case .artist:
            return RawValue.artist.rawValue
        case .album:
            return RawValue.album.rawValue
        case .track:
            return RawValue.track.rawValue
        case .photoAlbum:
            return RawValue.photoAlbum.rawValue
        case .picture:
            return RawValue.picture.rawValue
        case .photo:
            return RawValue.photo.rawValue
        case .playlist:
            return RawValue.playlist.rawValue
        case .playlistFolder:
            return RawValue.playlistFolder.rawValue
        case .userPlaylistItem:
            return RawValue.userPlaylistItem.rawValue
        case .collection:
            return RawValue.collection.rawValue
        }
    }

    enum RawValue: String, Codable, CaseIterable {
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
}

extension PlexMediaType: Codable {
    public init(from decoder: Decoder) throws {
        let rawValue = try decoder.singleValueContainer().decode(String.self)
        self.init(rawValue: rawValue)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

extension PlexMediaType {
    var key: Int {
        switch self {
        case .unknown:
            return -1

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
