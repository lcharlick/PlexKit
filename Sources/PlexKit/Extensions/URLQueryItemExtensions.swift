//
//  URLQueryItemExtensions.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 29/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

extension URLQueryItem {
    init(name: String, value: Bool) {
        self.init(name: name, value: value ? "1" : "0")
    }

    init(name: String, value: Int) {
        self.init(name: name, value: String(value))
    }
}
