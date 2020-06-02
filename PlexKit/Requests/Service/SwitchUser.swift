//
//  SwitchUser.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 31/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

public extension Plex.ServiceRequest {
    struct SwitchUser: PlexServiceRequest {
        public var path: String {
            "api/v2/home/users/\(uuid)/switch"
        }

        public var queryItems: [URLQueryItem]? {
            passCode.map {
                [.init(name: "pin", value: $0)]
            }
        }

        public let httpMethod = "POST"

        /// - SeeAlso: The `uuid` property of `HomeUser`.
        private let uuid: String
        private let passCode: String?

        public init(
            uuid: String,
            passCode: String? = nil
        ) {
            self.uuid = uuid
            self.passCode = passCode
        }

        public typealias Response = PlexUser
    }
}
