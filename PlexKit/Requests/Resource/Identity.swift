//
//  Identity.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 27/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

public extension Plex.Request {
    /// Fetch basic resource information.
    struct Identity: PlexResourceRequest {
        public let path = "identity"

        public init() {}

        public struct Response: Codable {
            public let mediaContainer: MediaContainer
        }
    }
}

public extension Plex.Request.Identity.Response {
    enum CodingKeys: String, CodingKey {
        case mediaContainer = "MediaContainer"
    }

    struct MediaContainer: Codable {
        public let size: Int
        public let machineIdentifier: String
        public let version: String
    }
}
