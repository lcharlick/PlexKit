//
//  ResponsePerformanceTests.swift
//  PlexKitTests
//
//  Created by Lachlan Charlick on 28/2/22.
//  Copyright © 2022 Lachlan Charlick. All rights reserved.
//

import XCTest
import PlexKit

class ResponsePerformanceTests: XCTestCase {
    func testPlaylistItemsResponsePerformance() throws {
        let data = try loadResource("playlist", ext: "json")
        self.measure {
            do {
                for _ in 0...1_000 {
                    let response = try Plex.Request._PlaylistItems<BasicPlexMediaItem>.response(from: data)
                    XCTAssertEqual(response.mediaContainer.size, 10)
                }
            } catch {
                XCTFail()
            }
        }
    }
}
