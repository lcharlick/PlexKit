//
//  URLExtensions.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 30/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

extension URL {
    func appendingQueryItems(_ items: [URLQueryItem]) -> URL? {
        guard var comps = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return nil
        }
        comps.queryItems = (comps.queryItems ?? []) + items
        return comps.url
    }
}
