//
//  PlexMediaTypeTests.swift
//  PlexKitTests
//
//  Created by Lachlan Charlick on 1/2/21.
//  Copyright © 2021 Lachlan Charlick. All rights reserved.
//

@testable import PlexKit
import XCTest

class PlexMediaTypeTests: XCTestCase {
    func testInitFromRawValue() {
        for value in PlexMediaType.RawValue.allCases {
            let mediaType = PlexMediaType(rawValue: value.rawValue)
            switch mediaType {
            case .unknown:
                XCTFail("Unexpected `unknown` media type!")
            default:
                break
            }
            XCTAssertEqual(mediaType.rawValue, value.rawValue)
        }
    }

    func testDecoding() throws {
        let decoder = JSONDecoder()

        for value in PlexMediaType.RawValue.allCases {
            let mediaType = PlexMediaType(rawValue: value.rawValue)

            XCTAssertEqual(
                try decoder.decode(Container.self, from: """
                {"mediaType": "\(value.rawValue)"}
                """.data(using: .utf8)!).mediaType,
                mediaType
            )
        }

        XCTAssertEqual(
            try decoder.decode(Container.self, from: """
            {"mediaType": "hello"}
            """.data(using: .utf8)!).mediaType,
            .unknown("hello")
        )
    }
}

private struct Container: Codable {
    let mediaType: PlexMediaType
}
