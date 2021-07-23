//
//  Image.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 31/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

public extension Plex.Request {
    struct Image: PlexResourceRequest {
        /// The path to the image.
        public var path: String
        public let accept = "image/*"

        public init(path: Plex.ImagePath) {
            self.path = path.rawValue
        }

        public static func response(from data: Data) throws -> Data {
            data
        }
    }
}
