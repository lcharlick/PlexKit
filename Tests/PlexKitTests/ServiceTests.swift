//
//  ServiceTests.swift
//  PlexKitTests
//
//  Created by Lachlan Charlick on 30/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

@testable import PlexKit
import XCTest

final class ServiceTests: XCTestCase {}

extension ServiceTests {
    func testSessionHeaders() throws {
        let info = Plex.ClientInfo(
            clientIdentifier: "clientIdentifier",
            product: "product",
            version: "version",
            platform: "platform",
            platformVersion: "platformVersion",
            device: "device",
            deviceName: "deviceName",
            token: "token",
            sessionIdentifier: "sessionIdentifier"
        )

        let client = Plex(sessionConfiguration: .default, clientInfo: info)
        let headers = (client.session.configuration.httpAdditionalHeaders ?? [:]) as? [String: String] ?? [:]

        XCTAssertEqual(headers["X-Plex-Client-Identifier"], info.clientIdentifier)
        XCTAssertEqual(headers["X-Plex-Product"], info.product)
        XCTAssertEqual(headers["X-Plex-Version"], info.version)
        XCTAssertEqual(headers["X-Plex-Platform"], info.platform)
        XCTAssertEqual(headers["X-Plex-Platform-Version"], info.platformVersion)
        XCTAssertEqual(headers["X-Plex-Device"], info.device)
        XCTAssertEqual(headers["X-Plex-Device-Name"], info.deviceName)
        XCTAssertEqual(headers["X-Plex-Token"], info.token)
        XCTAssertEqual(headers["X-Plex-Session-Identifier"], info.sessionIdentifier)
    }
}
