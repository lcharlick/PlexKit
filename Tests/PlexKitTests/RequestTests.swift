//
//  RequestTests.swift
//  PlexKitTests
//
//  Created by Lachlan Charlick on 30/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

@testable import PlexKit
import XCTest

class RequestTests: XCTestCase {
    private let testURL = URL(string: "http://192.168.0.100:32400")!

    private struct RequestData {
        init(request: URLRequest) {
            let url = request.url!
            baseURL = url.removingQueryItems()
            httpMethod = request.httpMethod
            headers = request.allHTTPHeaderFields

            let items = url.queryItems?.map {
                ($0.name, $0.value)
            } ?? []

            queryItems = Dictionary(uniqueKeysWithValues: items)
        }

        let baseURL: URL
        let httpMethod: String?
        let queryItems: [String: String?]
        let headers: [String: String]?
    }
}

// MARK: - OAuth.

extension RequestTests {
    func testOAuth_noId() throws {
        let request = try Plex.ServiceRequest.OAuth()
            .asURLRequest(using: nil)

        XCTAssertEqual(request.httpMethod, "POST")

        let data = RequestData(request: request)

        XCTAssertEqual(
            data.baseURL,
            URL(string: "https://plex.tv/api/v2/pins")
        )

        XCTAssertEqual(data.headers, [
            "Accept": "application/json",
        ])

        XCTAssertEqual(data.queryItems, [
            "strong": "1",
        ])
    }

    func testOAuth_withId() throws {
        let id: Int64 = 1234
        let request = try Plex.ServiceRequest.OAuth(id: id)
            .asURLRequest(using: nil)

        XCTAssertEqual(request.httpMethod, "GET")

        let data = RequestData(request: request)

        XCTAssertEqual(
            data.baseURL,
            URL(string: "https://plex.tv/api/v2/pins/\(id)")
        )

        XCTAssertEqual(data.headers, [
            "Accept": "application/json",
        ])

        XCTAssertEqual(data.queryItems, [:])
    }

    func testOAuth_authenticationURL() throws {
        let response = Plex.ServiceRequest.OAuth.Response(
            id: 1234,
            clientIdentifier: "clientIdentifier",
            code: "code",
            product: nil,
            trusted: nil,
            expiresIn: nil,
            createdAt: nil,
            expiresAt: nil,
            authToken: nil,
            newRegistration: nil
        )

        let url = Plex.ServiceRequest.OAuth.authenticationURL(for: response)

        XCTAssertEqual(
            url.absoluteString,
            "https://app.plex.tv/auth#?clientID=\(response.clientIdentifier)&code=\(response.code)"
        )
    }
}

// MARK: - Account.

extension RequestTests {
    func testAccount() throws {
        let token = "token"
        let request = try Plex.ServiceRequest.Account()
            .asURLRequest(using: token)

        let data = RequestData(request: request)

        XCTAssertEqual(
            data.baseURL,
            URL(string: "https://plex.tv/users/account.json")
        )

        XCTAssertEqual(data.headers, [
            "Accept": "application/json",
            Plex.Header.token.rawValue: token,
        ])

        XCTAssertEqual(data.queryItems, [:])
    }
}

// MARK: - Home Users.

extension RequestTests {
    func testHomeUsers() throws {
        let token = "token"
        let request = try Plex.ServiceRequest.HomeUsers()
            .asURLRequest(using: token)

        let data = RequestData(request: request)

        XCTAssertEqual(
            data.baseURL,
            URL(string: "https://plex.tv/api/v2/home/users")
        )

        XCTAssertEqual(data.headers, [
            "Accept": "application/json",
            Plex.Header.token.rawValue: token,
        ])

        XCTAssertEqual(data.queryItems, [:])
    }
}

// MARK: - Switch User.

extension RequestTests {
    func testSwitchUser_noPassCode() throws {
        let uuid = "woof"
        let request = try Plex.ServiceRequest.SwitchUser(uuid: uuid)
            .asURLRequest(using: nil)

        XCTAssertEqual(request.httpMethod, "POST")

        let data = RequestData(request: request)

        XCTAssertEqual(
            data.baseURL,
            URL(string: "https://plex.tv/api/v2/home/users/\(uuid)/switch")
        )

        XCTAssertEqual(data.headers, [
            "Accept": "application/json",
        ])

        XCTAssertEqual(data.queryItems, [:])
    }

    func testSwitchUser_withPassCode() throws {
        let uuid = "woof"
        let passCode = "1234"
        let request = try Plex.ServiceRequest.SwitchUser(uuid: uuid, passCode: passCode)
            .asURLRequest(using: nil)

        let data = RequestData(request: request)

        XCTAssertEqual(data.queryItems, [
            "pin": passCode,
        ])
    }
}

// MARK: - Resources.

extension RequestTests {
    func testResources() throws {
        let token = "token"
        let request = try Plex.ServiceRequest.Resources()
            .asURLRequest(using: token)

        let data = RequestData(request: request)

        XCTAssertEqual(
            data.baseURL,
            URL(string: "https://plex.tv/api/v2/resources")
        )

        XCTAssertEqual(data.headers, [
            "Accept": "application/json",
            Plex.Header.token.rawValue: token,
        ])

        XCTAssertEqual(data.queryItems, [
            "includeHttps": "1",
            "includeRelay": "1",
        ])
    }
}

// MARK: - Library Items.

extension RequestTests {
    func testLibraryContents() throws {
        let key = "key"
        let mediaType = PlexMediaType.album
        let token = "token"
        let url = URL(string: "http://192.168.0.100:32400")!

        let request = try Plex.Request.LibraryItems(
            key: key,
            mediaType: mediaType
        ).asURLRequest(from: url, using: token)

        let data = RequestData(request: request)

        XCTAssertEqual(
            data.baseURL,
            url.appendingPathComponent("library/sections/\(key)/all")
        )

        XCTAssertEqual(data.headers, [
            "Accept": "application/json",
            Plex.Header.token.rawValue: token,
        ])

        XCTAssertEqual(data.queryItems, [
            "type": String(mediaType.key),
            "excludeFields": "file",
        ])
    }

    func testLibraryContents_withRange() throws {
        let request = try Plex.Request.LibraryItems(
            key: "key",
            mediaType: .album,
            range: 5 ... 100
        ).asURLRequest(from: testURL, using: "")

        let data = RequestData(request: request)
        XCTAssertEqual(data.queryItems["X-Plex-Container-Start"], "5")
        XCTAssertEqual(data.queryItems["X-Plex-Container-Size"], "95")
    }

    func testLibraryContents_withExcludeFields() throws {
        let exclude = "woof"
        let request = try Plex.Request.LibraryItems(
            key: "key",
            mediaType: .album,
            excludeFields: [exclude]
        ).asURLRequest(from: testURL, using: "")

        let data = RequestData(request: request)
        XCTAssertEqual(data.queryItems["excludeFields"]??.contains(exclude), true)
    }
}

// MARK: - Playlists.

extension RequestTests {
    func testPlaylists() throws {
        let token = "token"
        let playlistType = PlexPlaylistType.audio
        let request = try Plex.Request.Playlists(type: playlistType)
            .asURLRequest(from: testURL, using: token)

        let data = RequestData(request: request)

        XCTAssertEqual(
            data.baseURL,
            testURL.appendingPathComponent("/playlists")
        )

        XCTAssertEqual(data.headers, [
            "Accept": "application/json",
            Plex.Header.token.rawValue: token,
        ])

        XCTAssertEqual(data.queryItems, [
            "playlistType": playlistType.rawValue,
        ])
    }

    func testPlaylists_library() throws {
        let token = "token"
        let libraryKey = 10
        let playlistType = PlexPlaylistType.video
        let request = try Plex.Request.Playlists(
            type: playlistType,
            libraryKey: libraryKey
        )
        .asURLRequest(from: testURL, using: token)

        let data = RequestData(request: request)
        XCTAssertEqual(data.queryItems["sectionID"], String(libraryKey))
        XCTAssertEqual(data.httpMethod, "GET")
    }

    func testPlaylists_excludeSmart() throws {
        let token = "token"
        let playlistType = PlexPlaylistType.video
        let request = try Plex.Request.Playlists(
            type: playlistType,
            smart: false
        )
        .asURLRequest(from: testURL, using: token)

        let data = RequestData(request: request)
        XCTAssertEqual(data.queryItems["smart"], "0")
        XCTAssertEqual(data.httpMethod, "GET")
    }

    func testPlaylists_onlySmart() throws {
        let token = "token"
        let playlistType = PlexPlaylistType.video
        let request = try Plex.Request.Playlists(
            type: playlistType,
            smart: true
        )
        .asURLRequest(from: testURL, using: token)

        let data = RequestData(request: request)
        XCTAssertEqual(data.queryItems["smart"], "1")
        XCTAssertEqual(data.httpMethod, "GET")
    }

    func testPlaylists_create() throws {
        let token = "token"
        let title = "hello"
        let resource = "1234"
        let items = ["1", "2"]
        let playlistType = PlexPlaylistType.video
        let request = try Plex.Request.Playlists(
            action: .create(
                title: title,
                type: playlistType,
                resource: resource,
                itemRatingKeys: items
            )
        )
        .asURLRequest(from: testURL, using: token)

        let data = RequestData(request: request)
        XCTAssertEqual(data.queryItems, [
            "title": title,
            "type": playlistType.rawValue,
            "uri": "server://\(resource)/com.plexapp.plugins.library/library/metadata/\(items.joined(separator: ","))",
        ])
        XCTAssertEqual(data.httpMethod, "POST")
    }

    func testPlaylists_createWithNoItemsThrowsError() {
        XCTAssertThrowsError(try Plex.Request.Playlists(
            action: .create(
                title: "test",
                type: .video,
                resource: "test",
                itemRatingKeys: []
            )
        ))
    }

    func testPlaylists_delete() throws {
        let request = try Plex.Request.Playlists(
            action: .delete(
                ratingKey: "key"
            )
        )
        .asURLRequest(from: testURL, using: "")

        let data = RequestData(request: request)
        XCTAssertEqual(request.url?.path, "/playlists/key")
        XCTAssertEqual(data.httpMethod, "DELETE")
    }
}

// MARK: - Related Media.

extension RequestTests {
    func testSimilarArtists() throws {
        let ratingKey = "key"
        let token = "token"

        let request = try Plex.Request.RelatedMedia(
            ratingKey: ratingKey
        ).asURLRequest(from: testURL, using: token)

        let data = RequestData(request: request)

        XCTAssertEqual(
            data.baseURL,
            testURL.appendingPathComponent("/hubs/metadata/\(ratingKey)/related")
        )

        XCTAssertEqual(data.headers, [
            "Accept": "application/json",
            Plex.Header.token.rawValue: token,
        ])

        XCTAssertEqual(data.queryItems, [:])
    }
}

// MARK: - Image.

extension RequestTests {
    func testImage() throws {
        let path = "woof"
        let token = "token"

        let request = try Plex.Request.Image(
            path: path
        ).asURLRequest(from: testURL, using: token)

        let data = RequestData(request: request)

        XCTAssertEqual(
            data.baseURL,
            testURL.appendingPathComponent(path)
        )

        XCTAssertEqual(data.headers, [
            "Accept": "image/*",
            Plex.Header.token.rawValue: token,
        ])

        XCTAssertEqual(data.queryItems, [:])
    }
}

// MARK: - Transcode Image.

extension RequestTests {
    func testTranscodeImage() throws {
        let path = "woof"
        let token = "token"

        let request = try Plex.Request.TranscodeImage(
            key: path
        ).asURLRequest(from: testURL, using: token)

        let data = RequestData(request: request)

        XCTAssertEqual(
            data.baseURL,
            testURL.appendingPathComponent("photo/:/transcode")
        )

        XCTAssertEqual(data.headers, [
            "Accept": "image/*",
            Plex.Header.token.rawValue: token,
        ])

        XCTAssertEqual(data.queryItems, [
            "url": path,
            "minSize": "1",
        ])
    }

    func testTranscodeImage_withEffects() throws {
        let path = "woof"
        let token = "token"
        let size = CGSize(width: 100, height: 100)
        let blur = 100
        let saturation = 70
        let opacity = 50

        let request = try Plex.Request.TranscodeImage(
            key: path,
            size: size,
            minSize: false,
            blur: blur,
            saturation: saturation,
            opacity: opacity
        ).asURLRequest(from: testURL, using: token)

        let data = RequestData(request: request)

        XCTAssertEqual(
            data.baseURL,
            testURL.appendingPathComponent("photo/:/transcode")
        )

        XCTAssertEqual(data.headers, [
            "Accept": "image/*",
            Plex.Header.token.rawValue: token,
        ])

        XCTAssertEqual(data.queryItems, [
            "url": path,
            "minSize": "0",
            "width": "\(Int(size.width))",
            "height": "\(Int(size.height))",
            "blur": "\(blur)",
            "saturation": "\(saturation)",
            "opacity": "\(opacity)",
        ])
    }
}

// MARK: - Timeline.

extension RequestTests {
    func testTimeline() throws {
        let session = UUID()
        let key = "woof"
        let state = Plex.Request.Timeline.State.playing
        let currentTime = 60
        let duration = 100
        let token = "token"

        let request = try Plex.Request.Timeline(
            session: session,
            ratingKey: key,
            state: .playing,
            currentTime: currentTime,
            duration: duration,
            isContinuing: true

        ).asURLRequest(from: testURL, using: token)

        let data = RequestData(request: request)

        XCTAssertEqual(
            data.baseURL,
            testURL.appendingPathComponent(":/timeline")
        )

        XCTAssertEqual(data.headers, [
            "Accept": "application/xml",
            Plex.Header.token.rawValue: token,
        ])

        XCTAssertEqual(data.queryItems, [
            Plex.Header.sessionIdentifier.rawValue: session.uuidString,
            "ratingKey": key,
            "key": "/library/metadata/\(key)",
            "state": state.rawValue,
            "time": String(currentTime),
            "duration": String(duration),
            "continuing": "1",
            "hasMDE": "1",
        ])
    }
}

// MARK: - Edit Rating.

extension RequestTests {
    func testEditRating() throws {
        let key = "woof"
        let token = "token"
        let rating = 6

        let request = try Plex.Request.EditRating(
            ratingKey: key,
            rating: rating
        ).asURLRequest(from: testURL, using: token)

        let data = RequestData(request: request)

        XCTAssertEqual(
            data.baseURL,
            testURL.appendingPathComponent(":/rate")
        )

        XCTAssertEqual(data.headers, [
            "Accept": "*/*",
            Plex.Header.token.rawValue: token,
        ])

        XCTAssertEqual(data.queryItems, [
            "key": key,
            "rating": String(rating),
            "identifier": "com.plexapp.plugins.library",
        ])
    }

    func testEditRating_clamping() throws {
        let key = "woof"
        let token = "token"
        let rating = 12

        let request = try Plex.Request.EditRating(
            ratingKey: key,
            rating: rating
        ).asURLRequest(from: testURL, using: token)

        let data = RequestData(request: request)

        XCTAssertEqual(data.queryItems, [
            "key": key,
            "rating": "10", // Clamp to 0...10
            "identifier": "com.plexapp.plugins.library",
        ])
    }
}

// MARK: - Playlist Items.

extension RequestTests {
    func testGetPlaylistItems() throws {
        let request = try Plex.Request.PlaylistItems(
            ratingKey: "woof",
            action: .get
        ).asURLRequest(from: testURL, using: nil)

        let data = RequestData(request: request)
        XCTAssertEqual(data.queryItems, [:])
        XCTAssertEqual(data.httpMethod, "GET")
    }

    func testRemovePlaylistItem() throws {
        let request = try Plex.Request.PlaylistItems(
            ratingKey: "woof",
            action: .remove(
                ratingKey: "1"
            )
        ).asURLRequest(from: testURL, using: nil)

        let data = RequestData(request: request)
        XCTAssertEqual(request.url?.path, "/playlists/woof/items/1")
        XCTAssertEqual(data.queryItems, [:])
        XCTAssertEqual(data.httpMethod, "DELETE")
    }

    func testMovePlaylistItem() throws {
        let request = try Plex.Request.PlaylistItems(
            ratingKey: "woof",
            action: .move(
                ratingKey: "2",
                after: "1"
            )
        ).asURLRequest(from: testURL, using: nil)

        let data = RequestData(request: request)
        XCTAssertEqual(request.url?.path, "/playlists/woof/items/2/move")
        XCTAssertEqual(data.queryItems, [
            "after": "1",
        ])
        XCTAssertEqual(data.httpMethod, "PUT")
    }

    func testMovePlaylistItemToBeginning() throws {
        let request = try Plex.Request.PlaylistItems(
            ratingKey: "woof",
            action: .move(
                ratingKey: "2",
                after: nil
            )
        ).asURLRequest(from: testURL, using: nil)

        let data = RequestData(request: request)
        XCTAssertEqual(request.url?.path, "/playlists/woof/items/2/move")
        XCTAssertEqual(data.queryItems, [:])
        XCTAssertEqual(data.httpMethod, "PUT")
    }

    func testAddItemToPlaylist() throws {
        let ratingKey = "test"
        let itemRatingKeys = ["3", "1", "2"]
        let resource = "1234"

        let request = try Plex.Request.PlaylistItems(
            ratingKey: ratingKey,
            action: .add(
                resource: resource,
                ratingKeys: itemRatingKeys
            )
        )
        .asURLRequest(from: testURL, using: "")

        let data = RequestData(request: request)
        XCTAssertEqual(request.url?.path, "/playlists/\(ratingKey)/items")
        XCTAssertEqual(data.queryItems, [
            "uri": "server://\(resource)/com.plexapp.plugins.library/library/metadata/\(itemRatingKeys.joined(separator: ","))",
        ])
        XCTAssertEqual(data.httpMethod, "PUT")
    }

    func testRemoveItemFromPlaylist() throws {
        let ratingKey = "test"
        let itemRatingKey = "1234"

        let request = try Plex.Request.PlaylistItems(
            ratingKey: ratingKey,
            action: .remove(
                ratingKey: itemRatingKey
            )
        )
        .asURLRequest(from: testURL, using: "")

        let data = RequestData(request: request)
        XCTAssertEqual(request.url?.path, "/playlists/\(ratingKey)/items/\(itemRatingKey)")
        XCTAssertEqual(data.queryItems, [:])
        XCTAssertEqual(data.httpMethod, "DELETE")
    }
}

// MARK: - Extensions.

private extension URL {
    var queryItems: [URLQueryItem]? {
        URLComponents(url: self, resolvingAgainstBaseURL: true)?.queryItems
    }

    func removingQueryItems() -> URL {
        var comps = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        comps.queryItems = nil
        return comps.url!
    }
}
