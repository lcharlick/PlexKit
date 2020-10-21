//
//  PlexMediaItem.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 31/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

public struct PlexMediaItem: Codable, Hashable {
    public let ratingKey: String
    public let key: String
    public let parentRatingKey: String?
    public let grandparentRatingKey: String?
    public let guid: String?
    public let parentGuid: String?
    public let grandparentGuid: String?
    public let librarySectionID: Int?
    public let type: PlexMediaType
    public let title: String?
    public let titleSort: String?
    public let grandparentKey: String?
    public let parentKey: String?
    public let grandparentTitle: String?
    public let parentTitle: String?
    public let summary: String?
    public let index: Int?
    public let parentIndex: Int?
    public let ratingCount: Int?
    public let viewCount: Int?
    public let viewOffset: Int?
    public let lastViewedAt: Date?
    public let thumb: String?
    public let art: String?
    public let banner: String?
    public let parentThumb: String?
    public let grandparentThumb: String?
    public let grandparentArt: String?
    public let duration: Int?
    public let addedAt: Date?
    public let updatedAt: Date?
    public let originalTitle: String?
    public let rating: Double?
    public let userRating: Int?
    public let lastRatedAt: Date?
    public let year: Int?
    public let originallyAvailableAt: String?
    public let studio: String?
    public let tagline: String?
    public let contentRating: String?
    public let chapterSource: String?
    public let theme: String?
    public let parentTheme: String?
    public let grandparentTheme: String?
    public let loudnessAnalysisVersion: String?

    public let allowSync: Bool?
    public let leafCount: Int?
    public let viewedLeafCount: Int?
    public let childCount: Int?

    private let Media: [Media]?
    private let Genre: [Tag]?
    private let Country: [Tag]?
    private let Style: [Tag]?
    private let Mood: [Tag]?
    private let Director: [Tag]?
    private let Writer: [Tag]?
    private let Role: [Tag]?

    // Playlist.
    public let smart: Bool?
    public let playlistType: PlexPlaylistType?
    public let composite: String?

    public struct Tag: Codable, Hashable {
        public let id: Int?
        public let tag: String
    }

    public struct Media: Codable, Hashable {
        public let id: Int
        public let duration: Int?
        public let bitrate: Int?
        public let container: String?
        public let has64BitOffsets: Bool?
        public let optimizedForStreaming: Int?

        // Audio.
        public let audioChannels: Int?
        public let audioCodec: String?
        public let audioProfile: String?

        // Video.
        public let width: Int?
        public let height: Int?
        public let aspectRatio: Double?
        public let videoCodec: String?
        public let videoResolution: String?
        public let videoFrameRate: String?
        public let videoProfile: String?

        private let Part: [Part]?

        public var parts: [Part] {
            self.Part ?? []
        }
    }

    public struct Part: Codable, Hashable {
        public let id: Int
        public let key: String
        public let duration: Int?
        public let file: String?
        public let size: Int?
        public let container: String?
        public let hasThumbnail: String?
        public let audioProfile: String?
        public let videoProfile: String?
        public let has64BitOffsets: Bool?
        public let optimizedForStreaming: Bool?
    }
}

public extension PlexMediaItem {
    var media: [Media] {
        self.Media ?? []
    }

    var genres: [Tag] {
        self.Genre ?? []
    }

    var countries: [Tag] {
        self.Country ?? []
    }

    var styles: [Tag] {
        self.Style ?? []
    }

    var moods: [Tag] {
        self.Mood ?? []
    }

    var directors: [Tag] {
        self.Director ?? []
    }

    var writers: [Tag] {
        self.Writer ?? []
    }

    var roles: [Tag] {
        self.Role ?? []
    }

    var originallyReleasedAt: Date? {
        originallyAvailableAt.flatMap {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.date(from: $0)
        }
    }
}
