//
//  PlexResource.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 31/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

public struct PlexResource: Codable {
    public let clientIdentifier: String
    public let name: String
    public let product: String?
    public let productVersion: String?
    public let platform: String?
    public let platformVersion: String?
    public let device: String?
    public let createdAt: Date?
    public let lastSeenAt: Date?
    public let provides: String?
    public let ownerId: Int?
    public let sourceTitle: String?
    public let publicAddress: String?
    public let accessToken: String?
    public let owned: Bool?
    public let home: Bool?
    public let synced: Bool?
    public let relay: Bool?
    public let presence: Bool?
    public let httpsRequired: Bool?
    public let publicAddressMatches: Bool?
    public let dnsRebindingProtection: Bool?
    public let connections: [PlexConnection]
    public let natLoopbackSupported: Bool?

    public var capabilities: Set<Capability> {
        guard let provides = provides else { return Set() }
        return Set(provides.split(separator: ",")
            .map(String.init)
            .compactMap(Capability.init(rawValue:)))
    }

    public enum Capability: String {
        case client
        case server
        case player
        case controller
        case syncTarget = "sync-target"
        case pubSubPlayer = "pub-sub-player"
        case providerPlayback = "provider-playback"
    }
}

public struct PlexConnection: Codable {
    public let `protocol`: NetworkProtocol?
    public let address: String
    public let port: Int
    public let uri: String
    public let local: Bool?
    public let relay: Bool?
    public let IPv6: Bool?

    public enum NetworkProtocol: String, Codable {
        case http
        case https
    }
}
