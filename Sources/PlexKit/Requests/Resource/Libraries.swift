//
//  Libraries.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 26/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

public extension Plex.Request {
    struct Libraries: PlexResourceRequest {
        public let path = "library/sections"

        public init() {}

        public struct Response: Codable {
            public let mediaContainer: MediaContainer
        }
    }
}

public extension Plex.Request.Libraries.Response {
    enum CodingKeys: String, CodingKey {
        case mediaContainer = "MediaContainer"
    }

    struct MediaContainer: Codable {
        public let size: Int
        public let allowSync: Bool?
        public let identifier: String?
        public let mediaTagPrefix: String?
        public let mediaTagVersion: Int?
        public let title1: String?
        private let Directory: [PlexLibrary]?
        public var directory: [PlexLibrary] { Directory ?? [] }
    }
}
