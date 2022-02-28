//
//  ResponseTests.swift
//  PlexKitTests
//
//  Created by Lachlan Charlick on 26/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

@testable import PlexKit
import XCTest

class ResponseTests: XCTestCase {
    func loadResponse<R: BasePlexRequest>(
        _ name: String,
        for _: R.Type
    ) throws -> R.Response {
        let data = try loadResource(name, ext: "json")
        return try R.response(from: data)
    }
}

// MARK: - Simple Authentication.

extension ResponseTests {
    func testSimpleAuthentication() throws {
        let response = try loadResponse(
            "simple_authentication",
            for: Plex.ServiceRequest.SimpleAuthentication.self
        )

        let user = response.user
        XCTAssertEqual(user.id, 123_456)
        XCTAssertEqual(user.uuid, "uuid")
        XCTAssertEqual(user.email, "email")
        XCTAssertEqual(
            ISO8601DateFormatter().string(from: user.joinedAt!),
            "2012-07-20T15:56:55Z"
        )
        XCTAssertEqual(user.username, "username")
        XCTAssertEqual(user.title, "title")
        XCTAssertEqual(user.thumb, "thumb")
        XCTAssertTrue(user.hasPassword)
        XCTAssertEqual(user.authToken, "authToken")
        XCTAssertEqual(user.authenticationToken, "authentication_token")
        XCTAssertEqual(
            ISO8601DateFormatter().string(from: user.confirmedAt ?? Date()),
            "2012-08-09T09:37:16Z"
        )
    }
}

// MARK: - OAuth.

extension ResponseTests {
    func testPin_noId() throws {
        let response = try loadResponse(
            "pin_no_id",
            for: Plex.ServiceRequest.OAuth.self
        )
        XCTAssertEqual(response.id, 1_291_057_671)
        XCTAssertEqual(response.code, "XY7Z")
        XCTAssertEqual(response.product, "0")
        XCTAssertEqual(response.trusted, false)
        XCTAssertEqual(response.clientIdentifier, "clientIdentifier")
        XCTAssertEqual(response.expiresIn, 900)
        XCTAssertEqual(
            response.createdAt.flatMap(ISO8601DateFormatter().string),
            "2020-05-30T14:59:05Z"
        )
        XCTAssertEqual(
            response.expiresAt.flatMap(ISO8601DateFormatter().string),
            "2020-05-30T15:14:05Z"
        )
        XCTAssertEqual(response.authToken, nil)
        XCTAssertEqual(response.newRegistration, nil)
    }

    func testPin() throws {
        let response = try loadResponse(
            "pin",
            for: Plex.ServiceRequest.OAuth.self
        )
        XCTAssertEqual(response.authToken, "authToken")
    }
}

// MARK: - Home Users.

extension ResponseTests {
    func testHomeUsers() throws {
        let response = try loadResponse(
            "home_users",
            for: Plex.ServiceRequest.HomeUsers.self
        )

        XCTAssertEqual(response.id, 1)
        XCTAssertEqual(response.name, "my home")
        XCTAssertEqual(response.guestUserID, 1000)
        XCTAssertEqual(response.guestUserUUID, "guestUserUUID")
        XCTAssertEqual(response.guestEnabled, false)
        XCTAssertEqual(response.subscription, true)
        XCTAssertGreaterThan(response.users?.count ?? 0, 0)

        let user = response.users?.first
        XCTAssertEqual(user?.id, 1234)
        XCTAssertEqual(user?.uuid, "uuid")
        XCTAssertEqual(user?.title, "title")
        XCTAssertEqual(user?.username, "username")
        XCTAssertEqual(user?.email, "email")
        XCTAssertEqual(user?.thumb, "thumb")
        XCTAssertEqual(user?.hasPassword, true)
        XCTAssertEqual(user?.restricted, false)
        XCTAssertEqual(user?.admin, true)
        XCTAssertEqual(user?.guest, false)
        XCTAssertEqual(user?.protected, true)
    }
}

// MARK: - Switch User.

extension ResponseTests {
    func testSwitchUser() throws {
        let user = try loadResponse(
            "switch_user",
            for: Plex.ServiceRequest.SwitchUser.self
        )

        XCTAssertEqual(user.id, 123)
        XCTAssertEqual(user.uuid, "uuid")
        XCTAssertEqual(user.title, "title")
        XCTAssertEqual(user.username, "username")
        XCTAssertEqual(user.email, "email")
        XCTAssertEqual(user.thumb, "thumb")
        XCTAssertEqual(user.hasPassword, true)
        XCTAssertEqual(user.home, true)
    }
}

// MARK: - Identity.

extension ResponseTests {
    func testIdentity() throws {
        let response = try loadResponse(
            "identity",
            for: Plex.Request.Identity.self
        )
        XCTAssertEqual(response.mediaContainer.size, 0)
        XCTAssertEqual(response.mediaContainer.machineIdentifier, "identifier")
        XCTAssertEqual(response.mediaContainer.version, "version")
    }
}

// MARK: - Resources.

extension ResponseTests {
    func testResources() throws {
        let response = try loadResponse(
            "resources",
            for: Plex.ServiceRequest.Resources.self
        )

        XCTAssertGreaterThan(response.count, 0)

        let resource = response[0]
        XCTAssertEqual(resource.name, "name")
        XCTAssertEqual(resource.product, "Plex Media Server")
        XCTAssertEqual(resource.productVersion, "1.16.1.1291-158e5b199")
        XCTAssertEqual(resource.platform, "Linux")
        XCTAssertEqual(resource.platformVersion, "7 (Core)")
        XCTAssertEqual(resource.device, "PC")
        XCTAssertEqual(resource.clientIdentifier, "clientIdentifier")
        XCTAssertEqual(
            resource.createdAt.flatMap(ISO8601DateFormatter().string),
            "2019-07-11T06:45:07Z"
        )
        XCTAssertEqual(
            resource.lastSeenAt.flatMap(ISO8601DateFormatter().string),
            "2020-05-29T12:01:13Z"
        )
        XCTAssertEqual(resource.provides, "server")
        XCTAssertNil(resource.ownerId)
        XCTAssertNil(resource.sourceTitle)
        XCTAssertEqual(resource.publicAddress, "publicAddress")
        XCTAssertEqual(resource.accessToken, "accessToken")
        XCTAssertEqual(resource.owned, true)
        XCTAssertEqual(resource.home, false)
        XCTAssertEqual(resource.synced, false)
        XCTAssertEqual(resource.relay, true)
        XCTAssertEqual(resource.presence, true)
        XCTAssertEqual(resource.httpsRequired, false)
        XCTAssertEqual(resource.publicAddressMatches, false)
        XCTAssertEqual(resource.dnsRebindingProtection, false)

        XCTAssertEqual(
            resource.capabilities,
            Set([PlexResource.Capability.server])
        )

        // Connections.

        XCTAssertGreaterThan(resource.connections.count, 0)

        let connection = resource.connections[0]
        XCTAssertEqual(connection.protocol, .http)
        XCTAssertEqual(connection.address, "address")
        XCTAssertEqual(connection.port, 32400)
        XCTAssertEqual(connection.uri, "uri")
        XCTAssertEqual(connection.local, false)
        XCTAssertEqual(connection.relay, false)
        XCTAssertEqual(connection.IPv6, false)
    }

    func testResources_noConnections() throws {
        // Resources may not contain a `connections` property under some circumstances.
        let response = try loadResponse(
            "resources_no_connections",
            for: Plex.ServiceRequest.Resources.self
        )

        XCTAssertGreaterThan(response.count, 0)
    }
}

// MARK: - Libraries.

extension ResponseTests {
    func testLibraries() throws {
        let response = try loadResponse(
            "libraries",
            for: Plex.Request.Libraries.self
        )

        XCTAssertGreaterThan(response.mediaContainer.directory.count, 0)
        XCTAssertEqual(
            response.mediaContainer.directory.count,
            response.mediaContainer.size
        )
    }

    func testLibraryValues() throws {
        let response = try loadResponse(
            "library",
            for: Plex.Request.Libraries.self
        )

        let library = response.mediaContainer.directory[0]

        XCTAssertEqual(library.art, "/:/resources/artist-fanart.jpg")
        XCTAssertEqual(library.composite, "/library/sections/29/composite/1533454149")
        XCTAssertEqual(library.filters, true)
        XCTAssertEqual(library.refreshing, false)
        XCTAssertEqual(library.thumb, "/:/resources/artist.png")
        XCTAssertEqual(library.key, "29")
        XCTAssertEqual(library.type, .artist)
        XCTAssertEqual(library.title, "Music")
        XCTAssertEqual(library.agent, "com.plexapp.agents.lastfm")
        XCTAssertEqual(library.scanner, "Plex Music Scanner")
        XCTAssertEqual(library.language, "en")
        XCTAssertEqual(library.uuid, "63c7dcc8-4d41-41f1-b103-6fe124ca324c")
        XCTAssertEqual(library.createdAt?.timeIntervalSince1970, 1_461_341_110)
        XCTAssertEqual(library.updatedAt?.timeIntervalSince1970, 1_513_603_096)
        XCTAssertEqual(library.scannedAt?.timeIntervalSince1970, 1_533_454_149)
    }
}

// MARK: - Library Items.

extension ResponseTests {
    func testLibraryContents_tracks() throws {
        let response = try loadResponse(
            "tracks",
            for: Plex.Request.LibraryItems.self
        )

        XCTAssertEqual(
            response.mediaContainer.size,
            response.mediaContainer.metadata.count
        )

        let item = response.mediaContainer.metadata[0]
        XCTAssertEqual(item.ratingKey, "403870")
        XCTAssertEqual(item.key, "/library/metadata/403870")
        XCTAssertEqual(item.parentRatingKey, "403868")
        XCTAssertEqual(item.grandparentRatingKey, "403867")
        XCTAssertEqual(item.guid, "plex://track/5d07eda5403c640290e73381")
        XCTAssertEqual(item.parentGuid, "plex://album/5d07c957403c640290c7da40")
        XCTAssertEqual(item.grandparentGuid, "plex://artist/5d07bc35403c6402904d32d4")
        XCTAssertEqual(item.type, .track)
        XCTAssertEqual(item.title, "The Thing That Made Search")
        XCTAssertEqual(item.titleSort, "Thing That Made Search")
        XCTAssertEqual(item.grandparentKey, "/library/metadata/403867")
        XCTAssertEqual(item.parentKey, "/library/metadata/403868")
        XCTAssertEqual(item.grandparentTitle, "Ahab")
        XCTAssertEqual(item.parentTitle, "The Boats of the Glen Carrig")
        XCTAssertEqual(item.summary, "")
        XCTAssertEqual(item.index, 2)
        XCTAssertEqual(item.parentIndex, 1)
        XCTAssertEqual(item.ratingCount, 7382)
        XCTAssertEqual(item.viewCount, 2)
        XCTAssertEqual(item.lastViewedAt?.timeIntervalSince1970, 1_561_214_605)
        XCTAssertEqual(item.thumb, "/library/metadata/403868/thumb/1581395296")
        XCTAssertEqual(item.art, "/library/metadata/403867/art/1590339692")
        XCTAssertEqual(item.parentThumb, "/library/metadata/403868/thumb/1581395296")
        XCTAssertEqual(item.grandparentThumb, "/library/metadata/403867/thumb/1590339692")
        XCTAssertEqual(item.grandparentArt, "/library/metadata/403867/art/1590339692")
        XCTAssertEqual(item.duration, 666_697)
        XCTAssertEqual(item.addedAt?.timeIntervalSince1970, 1_522_735_822)
        XCTAssertEqual(item.updatedAt?.timeIntervalSince1970, 1_581_395_296)
        XCTAssertNotNil(item.media)
        XCTAssertEqual(item.media.count, 1)

        let media = item.media.first

        XCTAssertEqual(media?.id, 397_724)
        XCTAssertEqual(media?.duration, 666_697)
        XCTAssertEqual(media?.bitrate, 192)
        XCTAssertEqual(media?.audioChannels, 2)
        XCTAssertEqual(media?.audioCodec, "mp3")
        XCTAssertEqual(media?.container, "mp3")
        XCTAssertNotNil(media?.parts)
        XCTAssertEqual(media?.parts.count, 1)

        let part = media?.parts.first

        XCTAssertEqual(part?.id, 403_991)
        XCTAssertEqual(part?.key, "/library/parts/403991/1474300012/file.mp3")
        XCTAssertEqual(part?.duration, 666_697)
        XCTAssertEqual(
            part?.file,
            "/mnt/music_demo/Ahab/2015 - The Boats of the Glen Carrig/02 - The Thing That Made Search.mp3"
        )
        XCTAssertEqual(part?.size, 16_448_855)
        XCTAssertEqual(part?.container, "mp3")
        XCTAssertEqual(part?.hasThumbnail, "1")
    }

    func testLibraryContents_trackWithProgress() throws {
        let response = try loadResponse(
            "track_with_progress",
            for: Plex.Request.LibraryItems.self
        )

        XCTAssertEqual(
            response.mediaContainer.metadata.first?.viewOffset,
            3_282_433
        )
    }

    func testLibraryContents_albums() throws {
        let response = try loadResponse(
            "albums",
            for: Plex.Request.LibraryItems.self
        )

        XCTAssertEqual(
            response.mediaContainer.size,
            response.mediaContainer.metadata.count
        )

        let item = response.mediaContainer.metadata[0]

        XCTAssertEqual(item.ratingKey, "474523")
        XCTAssertEqual(item.key, "/library/metadata/474523/children")
        XCTAssertEqual(item.parentRatingKey, "474522")
        XCTAssertEqual(item.guid, "com.plexapp.agents.lastfm://Agalloch%20/%20Nest/Agalloch%20/%20Nest?lang=en")
        XCTAssertEqual(item.parentGuid, "com.plexapp.agents.lastfm://Agalloch%20/%20Nest?lang=en")
        XCTAssertEqual(item.type, .album)
        XCTAssertEqual(item.title, "Agalloch / Nest")
        XCTAssertEqual(item.parentKey, "/library/metadata/474522")
        XCTAssertEqual(item.parentTitle, "Agalloch / Nest")
        XCTAssertEqual(item.summary, "")
        XCTAssertEqual(item.index, 1)
        XCTAssertEqual(item.viewCount, 24)
        XCTAssertEqual(item.lastViewedAt?.timeIntervalSince1970, 1_558_532_350)
        XCTAssertEqual(item.year, 2004)
        XCTAssertEqual(item.thumb, "/library/metadata/474523/thumb/1581395273")
        XCTAssertEqual(item.art, "/library/metadata/474522/art/1590339695")
        XCTAssertEqual(item.parentThumb, "/library/metadata/474522/thumb/1590339695")
        XCTAssertEqual(item.originallyAvailableAt, "2004-01-01")
        XCTAssertEqual(item.addedAt?.timeIntervalSince1970, 1_574_832_896)
        XCTAssertEqual(item.updatedAt?.timeIntervalSince1970, 1_581_395_273)
    }

    func testLibraryContents_artists() throws {
        let response = try loadResponse(
            "artists",
            for: Plex.Request.LibraryItems.self
        )

        XCTAssertEqual(
            response.mediaContainer.size,
            response.mediaContainer.metadata.count
        )

        let item = response.mediaContainer.metadata[0]

        XCTAssertEqual(item.ratingKey, "399775")
        XCTAssertEqual(item.key, "/library/metadata/399775/children")
        XCTAssertEqual(item.type, .artist)
        XCTAssertEqual(item.title, "Agalloch")
        XCTAssertEqual(
            item.summary?.starts(with: "Agalloch was an American metal band formed in Portland, Oregon"),
            true
        )
        XCTAssertEqual(item.index, 1)
        XCTAssertEqual(item.viewCount, 69)
        XCTAssertEqual(item.lastViewedAt?.timeIntervalSince1970, 1_532_874_929)
        XCTAssertEqual(item.thumb, "/library/metadata/399775/thumb/1533232019")
        XCTAssertEqual(item.art, "/library/metadata/399775/art/1533232019")
        XCTAssertEqual(item.addedAt?.timeIntervalSince1970, 1_508_135_035)
        XCTAssertEqual(item.updatedAt?.timeIntervalSince1970, 1_533_232_019)
        XCTAssertNotNil(item.genres)
        XCTAssertEqual(item.genres.count, 2)

        XCTAssertEqual(item.genres, [
            .init(tag: "Black Metal"),
            .init(tag: "Doom Metal"),
        ])
    }

    func testLibraryContents_movies() throws {
        let response = try loadResponse(
            "movie",
            for: Plex.Request.LibraryItems.self
        )

        XCTAssertEqual(
            response.mediaContainer.size,
            response.mediaContainer.metadata.count
        )

        let item = response.mediaContainer.metadata[0]

        XCTAssertEqual(item.ratingKey, "246169")
        XCTAssertEqual(item.key, "/library/metadata/246169")
        XCTAssertEqual(item.guid, "com.plexapp.agents.themoviedb://348?lang=en")
        XCTAssertEqual(item.studio, "20th Century Fox")
        XCTAssertEqual(item.type, .movie)
        XCTAssertEqual(item.title, "Alien")
        XCTAssertEqual(item.contentRating, "R")
        XCTAssertEqual(
            item.summary?.starts(with: "During its return to the earth, commercial spaceship Nostromo"),
            true
        )
        XCTAssertEqual(item.rating, 8.1)
        XCTAssertEqual(item.year, 1979)
        XCTAssertEqual(item.tagline, "In space no one can hear you scream.")
        XCTAssertEqual(item.thumb, "/library/metadata/246169/thumb/1560012400")
        XCTAssertEqual(item.art, "/library/metadata/246169/art/1560012400")
        XCTAssertEqual(item.duration, 6_997_616)
        XCTAssertEqual(item.originallyAvailableAt, "1979-05-25")
        XCTAssertEqual(item.addedAt?.timeIntervalSince1970, 1_449_039_414)
        XCTAssertEqual(item.updatedAt?.timeIntervalSince1970, 1_560_012_400)
        XCTAssertEqual(item.chapterSource, "agent")

        XCTAssertEqual(item.genres, [
            .init(tag: "Horror"),
            .init(tag: "Science Fiction"),
        ])

        XCTAssertEqual(item.countries, [
            .init(tag: "USA"),
            .init(tag: "United Kingdom"),
        ])

        XCTAssertEqual(item.directors, [
            .init(tag: "Ridley Scott"),
        ])

        XCTAssertEqual(item.writers, [
            .init(tag: "Dan O'Bannon"),
        ])

        let media = item.media.first

        XCTAssertEqual(media?.id, 220_442)
        XCTAssertEqual(media?.duration, 6_997_616)
        XCTAssertEqual(media?.bitrate, 9434)
        XCTAssertEqual(media?.width, 1920)
        XCTAssertEqual(media?.height, 816)
        XCTAssertEqual(media?.aspectRatio, 2.35)
        XCTAssertEqual(media?.audioChannels, 6)
        XCTAssertEqual(media?.audioCodec, "dca")
        XCTAssertEqual(media?.videoCodec, "h264")
        XCTAssertEqual(media?.videoResolution, "1080")
        XCTAssertEqual(media?.container, "mkv")
        XCTAssertEqual(media?.videoFrameRate, "24p")
        XCTAssertEqual(media?.audioProfile, "dts")
        XCTAssertEqual(media?.videoProfile, "high")

        let part = media?.parts.first

        XCTAssertEqual(part?.id, 224_807)
        XCTAssertEqual(part?.key, "/library/parts/224807/1449039336/file.mkv")
        XCTAssertEqual(part?.duration, 6_997_616)
        XCTAssertEqual(part?.file, "/mnt/movies/Alien (1979)/Alien.mkv")
        XCTAssertEqual(part?.size, 8_251_845_873)
        XCTAssertEqual(part?.audioProfile, "dts")
        XCTAssertEqual(part?.container, "mkv")
        XCTAssertEqual(part?.videoProfile, "high")
    }

    func testLibraryContents_shows() throws {
        let response = try loadResponse(
            "show",
            for: Plex.Request.LibraryItems.self
        )

        XCTAssertEqual(
            response.mediaContainer.size,
            response.mediaContainer.metadata.count
        )

        let item = response.mediaContainer.metadata[0]

        XCTAssertEqual(item.ratingKey, "37250")
        XCTAssertEqual(item.key, "/library/metadata/37250/children")
        XCTAssertEqual(item.guid, "com.plexapp.agents.thetvdb://74205?lang=en")
        XCTAssertEqual(item.studio, "HBO")
        XCTAssertEqual(item.type, .show)
        XCTAssertEqual(item.title, "Band of Brothers")
        XCTAssertEqual(item.contentRating, "TV-MA")
        XCTAssertEqual(
            item.summary?.starts(with: "The miniseries follows Easy Company, an army unit during World War II"),
            true
        )
        XCTAssertEqual(item.index, 1)
        XCTAssertEqual(item.rating, 9.4)
        XCTAssertEqual(item.viewCount, 8)
        XCTAssertEqual(item.lastViewedAt?.timeIntervalSince1970, 1_477_036_961)
        XCTAssertEqual(item.year, 2001)
        XCTAssertEqual(item.thumb, "/library/metadata/37250/thumb/1559967326")
        XCTAssertEqual(item.art, "/library/metadata/37250/art/1559967326")
        XCTAssertEqual(item.banner, "/library/metadata/37250/banner/1559967326")
        XCTAssertEqual(item.theme, "/library/metadata/37250/theme/1559967326")
        XCTAssertEqual(item.duration, 3_600_000)
        XCTAssertEqual(item.originallyAvailableAt, "2001-09-09")
        XCTAssertEqual(item.leafCount, 10)
        XCTAssertEqual(item.viewedLeafCount, 8)
        XCTAssertEqual(item.childCount, 1)
        XCTAssertEqual(item.addedAt?.timeIntervalSince1970, 1_427_433_010)
        XCTAssertEqual(item.updatedAt?.timeIntervalSince1970, 1_559_967_326)
    }

    func testLibraryContents_seasons() throws {
        let response = try loadResponse(
            "season",
            for: Plex.Request.LibraryItems.self
        )

        XCTAssertEqual(
            response.mediaContainer.size,
            response.mediaContainer.metadata.count
        )

        let item = response.mediaContainer.metadata[0]

        XCTAssertEqual(item.ratingKey, "37251")
        XCTAssertEqual(item.key, "/library/metadata/37251/children")
        XCTAssertEqual(item.parentRatingKey, "37250")
        XCTAssertEqual(item.guid, "com.plexapp.agents.thetvdb://74205/1?lang=en")
        XCTAssertEqual(item.parentGuid, "com.plexapp.agents.thetvdb://74205?lang=en")
        XCTAssertEqual(item.type, .season)
        XCTAssertEqual(item.title, "Season 1")
        XCTAssertEqual(item.parentKey, "/library/metadata/37250")
        XCTAssertEqual(item.parentTitle, "Band of Brothers")
        XCTAssertEqual(item.summary, "")
        XCTAssertEqual(item.index, 1)
        XCTAssertEqual(item.parentIndex, 1)
        XCTAssertEqual(item.viewCount, 8)
        XCTAssertEqual(item.lastViewedAt?.timeIntervalSince1970, 1_477_036_961)
        XCTAssertEqual(item.thumb, "/library/metadata/37251/thumb/1559967326")
        XCTAssertEqual(item.art, "/library/metadata/37250/art/1559967326")
        XCTAssertEqual(item.parentThumb, "/library/metadata/37250/thumb/1559967326")
        XCTAssertEqual(item.parentTheme, "/library/metadata/37250/theme/1559967326")
        XCTAssertEqual(item.addedAt?.timeIntervalSince1970, 1_427_433_010)
        XCTAssertEqual(item.updatedAt?.timeIntervalSince1970, 1_559_967_326)
    }

    func testLibraryContents_episodes() throws {
        let response = try loadResponse(
            "episode",
            for: Plex.Request.LibraryItems.self
        )

        XCTAssertEqual(
            response.mediaContainer.size,
            response.mediaContainer.metadata.count
        )

        let item = response.mediaContainer.metadata[0]

        XCTAssertEqual(item.ratingKey, "37262")
        XCTAssertEqual(item.key, "/library/metadata/37262")
        XCTAssertEqual(item.parentRatingKey, "37251")
        XCTAssertEqual(item.grandparentRatingKey, "37250")
        XCTAssertEqual(item.guid, "com.plexapp.agents.thetvdb://74205/1/1?lang=en")
        XCTAssertEqual(item.parentGuid, "com.plexapp.agents.thetvdb://74205/1?lang=en")
        XCTAssertEqual(item.grandparentGuid, "com.plexapp.agents.thetvdb://74205?lang=en")
        XCTAssertEqual(item.type, .episode)
        XCTAssertEqual(item.title, "Currahee")
        XCTAssertEqual(item.grandparentKey, "/library/metadata/37250")
        XCTAssertEqual(item.parentKey, "/library/metadata/37251")
        XCTAssertEqual(item.grandparentTitle, "Band of Brothers")
        XCTAssertEqual(item.parentTitle, "Season 1")
        XCTAssertEqual(item.contentRating, "TV-MA")
        XCTAssertEqual(item.summary?.starts(with: "Easy Company is introduced to Captain Sobel"), true)
        XCTAssertEqual(item.index, 1)
        XCTAssertEqual(item.parentIndex, 1)
        XCTAssertEqual(item.rating, 8.4)
        XCTAssertEqual(item.viewCount, 1)
        XCTAssertEqual(item.lastViewedAt?.timeIntervalSince1970, 1_472_114_415)
        XCTAssertEqual(item.year, 2001)
        XCTAssertEqual(item.thumb, "/library/metadata/37262/thumb/1590057326")
        XCTAssertEqual(item.art, "/library/metadata/37250/art/1559967326")
        XCTAssertEqual(item.parentThumb, "/library/metadata/37251/thumb/1559967326")
        XCTAssertEqual(item.grandparentThumb, "/library/metadata/37250/thumb/1559967326")
        XCTAssertEqual(item.grandparentArt, "/library/metadata/37250/art/1559967326")
        XCTAssertEqual(item.grandparentTheme, "/library/metadata/37250/theme/1559967326")
        XCTAssertEqual(item.duration, 4_394_123)
        XCTAssertEqual(item.originallyAvailableAt, "2001-09-09")
        XCTAssertEqual(item.addedAt?.timeIntervalSince1970, 1_427_434_150)
        XCTAssertEqual(item.updatedAt?.timeIntervalSince1970, 1_590_057_326)

        let media = item.media.first

        XCTAssertEqual(media?.id, 32610)
        XCTAssertEqual(media?.duration, 4_394_123)
        XCTAssertEqual(media?.bitrate, 8000)
        XCTAssertEqual(media?.width, 1280)
        XCTAssertEqual(media?.height, 720)
        XCTAssertEqual(media?.aspectRatio, 1.78)
        XCTAssertEqual(media?.audioChannels, 6)
        XCTAssertEqual(media?.audioCodec, "dca")
        XCTAssertEqual(media?.videoCodec, "h264")
        XCTAssertEqual(media?.videoResolution, "720")
        XCTAssertEqual(media?.container, "mkv")
        XCTAssertEqual(media?.videoFrameRate, "24p")
        XCTAssertEqual(media?.audioProfile, "dts")
        XCTAssertEqual(media?.videoProfile, "high")

        let part = media?.parts.first

        XCTAssertEqual(part?.id, 35221)
        XCTAssertEqual(part?.key, "/library/parts/35221/1427352014/file.mkv")
        XCTAssertEqual(part?.duration, 4_394_123)
        XCTAssertEqual(part?.file, "/mnt/tv/Band of Brothers/Season 1/Band of Brothers - 01x01 - Currahee.mkv")
        XCTAssertEqual(part?.size, 4_394_246_749)
        XCTAssertEqual(part?.audioProfile, "dts")
        XCTAssertEqual(part?.container, "mkv")
        XCTAssertEqual(part?.videoProfile, "high")
    }
}

// MARK: - Item Metadata.

extension ResponseTests {
    func testItemMetadata() throws {
        let response = try loadResponse(
            "item_metadata",
            for: Plex.Request.ItemMetadata.self
        )

        XCTAssertEqual(
            response.mediaContainer.size,
            response.mediaContainer.metadata.count
        )
    }

    func testItemMetadataWithMultipleStreams() throws {
        let response = try loadResponse(
            "item_metadata_with_text_stream",
            for: Plex.Request.ItemMetadata.self
        )
        XCTAssertEqual(
            response.mediaContainer.size,
            response.mediaContainer.metadata.count
        )

        let item = response.mediaContainer.metadata[0]
        XCTAssertEqual(item.media.count, 1)

        guard let streams = item.media.first?.parts.first?.streams else {
            XCTFail("No streams found!")
            return
        }

        XCTAssertEqual(streams.count, 2)
        XCTAssertEqual(streams.filter { $0.type == .audio }.count, 1)
        XCTAssertEqual(streams.filter { $0.type == .lyrics }.count, 1)
    }
}

// MARK: - Playlists.

extension ResponseTests {
    func testPlaylists() throws {
        let response = try loadResponse(
            "playlists",
            for: Plex.Request.Playlists.self
        )

        XCTAssertEqual(
            response.mediaContainer.size,
            response.mediaContainer.metadata.count
        )

        let item = response.mediaContainer.metadata[0]
        XCTAssertEqual(item.allowSync, true)
        XCTAssertEqual(item.ratingKey, "404337")
        XCTAssertEqual(item.key, "/playlists/404337/items")
        XCTAssertEqual(item.guid, "com.plexapp.agents.none://3a370e2f-4c27-4677-a0de-634e5e7736d4")
        XCTAssertEqual(item.type, .playlist)
        XCTAssertEqual(item.title, "Test Playlist")
        XCTAssertEqual(item.summary, "")
        XCTAssertEqual(item.smart, false)
        XCTAssertEqual(item.playlistType, .audio)
        XCTAssertEqual(item.composite, "/playlists/404337/composite/1524830850")
        XCTAssertEqual(item.viewCount, 5)
        XCTAssertEqual(item.lastViewedAt?.timeIntervalSince1970, 1_524_734_209)
        XCTAssertEqual(item.duration, 4_107_000)
        XCTAssertEqual(item.leafCount, 9)
        XCTAssertEqual(item.addedAt?.timeIntervalSince1970, 1_523_543_021)
        XCTAssertEqual(item.updatedAt?.timeIntervalSince1970, 1_524_830_850)
    }

    func testPlaylistItems() throws {
        let response = try loadResponse(
            "playlist",
            for: Plex.Request.PlaylistItems.self
        )

        let container = response.mediaContainer

        XCTAssertEqual(
            container.size,
            container.metadata.count
        )

        XCTAssertEqual(container.size, 10)
        XCTAssertEqual(container.totalSize, 10)
        XCTAssertEqual(container.allowSync, true)
        XCTAssertEqual(container.composite, "/playlists/404337/composite/1524878869")
        XCTAssertEqual(container.duration, 4112)
        XCTAssertEqual(container.leafCount, 10)
        XCTAssertEqual(container.offset, 0)
        XCTAssertEqual(container.playlistType, .audio)
        XCTAssertEqual(container.ratingKey, "404337")
        XCTAssertEqual(container.smart, false)
        XCTAssertEqual(container.title, "Test Playlist")
    }
}

// MARK: - Related Media.

extension ResponseTests {
    func testCollections() throws {
        let response = try loadResponse(
            "collections",
            for: Plex.Request.Collections.self
        )

        XCTAssertEqual(
            response.mediaContainer.size,
            response.mediaContainer.directory.count
        )

        let item = response.mediaContainer.directory.first

        XCTAssertEqual(item?.key, "3286")
        XCTAssertEqual(item?.title, "Harry Potter")
    }

    func testCollections2() throws {
        let response = try loadResponse(
            "collections2",
            for: Plex.Request.Collections2.self
        )

        XCTAssertEqual(
            response.mediaContainer.size,
            response.mediaContainer.metadata.count
        )

        let collection = response.mediaContainer.metadata.first { $0.isSmart }
        XCTAssertEqual(collection?.ratingKey, "594667")
        XCTAssertEqual(collection?.key, "/library/collections/594667/children")
        XCTAssertEqual(collection?.guid, "collection://f969f524-3acb-4b59-b194-2bd356f03e6a")
        XCTAssertEqual(collection?.type, "collection")
        XCTAssertEqual(collection?.title, "Science Fiction")
        XCTAssertEqual(collection?.subtype, .album)
        XCTAssertEqual(collection?.summary, "")
        XCTAssertEqual(collection?.index, 197_069)
        XCTAssertEqual(collection?.ratingCount, 109)
        XCTAssertEqual(collection?.thumb, "/library/collections/594667/composite/1634550705?width=400&height=600")
        XCTAssertEqual(collection?.addedAt?.timeIntervalSince1970, 1_634_550_705)
        XCTAssertEqual(collection?.updatedAt?.timeIntervalSince1970, 1_634_550_705)
        XCTAssertEqual(collection?.childCount, "15")
    }

    func testCollectionItems() throws {
        let response = try loadResponse(
            "collection_items",
            for: Plex.Request.CollectionItems.self
        )

        XCTAssertEqual(
            response.mediaContainer.size,
            response.mediaContainer.metadata.count
        )
    }
}

// MARK: - Related Media.

extension ResponseTests {
    func testRelatedMedia() throws {
        let response = try loadResponse(
            "similar_artists",
            for: Plex.Request.RelatedMedia.self
        )

        XCTAssertEqual(
            response.mediaContainer.size,
            response.mediaContainer.hubs.count
        )

        let hub = response.mediaContainer.hubs[0]
        XCTAssertEqual(hub.title, "Similar Artists")
        XCTAssertEqual(hub.type, .artist)
        XCTAssertEqual(hub.hubIdentifier, "artist.similar")
        XCTAssertEqual(hub.size, hub.metadata.count)
    }
}

// MARK: - Extensions.

private extension PlexMediaItem.Tag {
    init(tag: String) {
        self.init(id: nil, tag: tag)
    }
}
