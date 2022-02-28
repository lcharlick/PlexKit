//
//  Util.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 28/2/22.
//  Copyright © 2022 Lachlan Charlick. All rights reserved.
//

import Foundation

func pageQueryItems(for range: CountableClosedRange<Int>) -> [URLQueryItem] {
    guard let start = range.first, let end = range.last else { return [] }
    return [
        URLQueryItem(name: "X-Plex-Container-Start", value: start),
        URLQueryItem(name: "X-Plex-Container-Size", value: end - start),
    ]
}
