//
//  PlexRequest.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 26/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

/// Describes a single Plex request.
public protocol BasePlexRequest: Sendable {
    associatedtype Response: Sendable

    var path: String { get }
    var queryItems: [URLQueryItem]? { get }

    var httpMethod: String { get }
    var accept: String { get }

    static func response(from data: Data) throws -> Response
}

public extension BasePlexRequest {
    var httpMethod: String { "GET" }
    var accept: String { "application/json" }
    var queryItems: [URLQueryItem]? { nil }
}

public extension BasePlexRequest where Response: Codable {
    static func _response(from data: Data) throws -> Response {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970

        // Check that we have valid utf8 data.
        // Internal JSONSerialization can crash under certain circumstances if `data` can't be decoded as utf8.
        guard String(data: data, encoding: .utf8) != nil else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Can't convert data to utf8 string"))
        }

        return try decoder.decode(Response.self, from: data)
    }

    static func response(from data: Data) throws -> Response {
        try _response(from: data)
    }
}

/// Describes a request to a plex resource (e.g. server).
public protocol PlexResourceRequest: BasePlexRequest {}

extension PlexResourceRequest {
    public func asURLRequest(
        from url: URL,
        using token: String?
    ) throws -> URLRequest {
        try _asURLRequest(from: url, using: token)
    }

    func _asURLRequest(
        from url: URL,
        using token: String?
    ) throws -> URLRequest {
        guard let url = url.appendingPathComponent(path)
            .appendingQueryItems(queryItems ?? [])
        else {
            throw PlexError.invalidRequest(.invalidQueryItems(queryItems ?? []))
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue(accept, forHTTPHeaderField: "accept")
        if let token = token {
            request.addValue(token, forHTTPHeaderField: "X-Plex-Token")
        }
        return request
    }
}

/// Describes a request to the plex.tv service.
public protocol PlexServiceRequest: BasePlexRequest {
    func asURLRequest(using token: String?) throws -> URLRequest
}

public extension PlexServiceRequest {
    func asURLRequest(using token: String?) throws -> URLRequest {
        let path = "https://plex.tv/\(self.path)"
        guard let url = URL(string: path)?.appendingQueryItems(queryItems ?? []) else {
            throw PlexError.invalidRequest(.invalidURL(path))
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue(accept, forHTTPHeaderField: "accept")

        if let token = token {
            request.addValue(token, forHTTPHeaderField: "X-Plex-Token")
        }

        return request
    }
}
