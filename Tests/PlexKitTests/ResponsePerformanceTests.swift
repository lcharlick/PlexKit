//
//  ResponsePerformanceTests.swift
//  PlexKitTests
//
//  Created by Lachlan Charlick on 28/2/22.
//  Copyright © 2022 Lachlan Charlick. All rights reserved.
//

import PlexKit
import XCTest

class ResponsePerformanceTests: XCTestCase {
    func testPlaylistItemsResponsePerformance() throws {
        let data = try loadResource("playlist", ext: "json")
        measure {
            do {
                for _ in 0 ... 1000 {
                    let response = try Plex.Request._PlaylistItems<BasicPlexMediaItem>.response(from: data)
                    XCTAssertEqual(response.mediaContainer.size, 10)
                }
            } catch {
                XCTFail()
            }
        }
    }
}
