//
//  PlexKit.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 26/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

// MARK: - Client.

public final class Plex {
    private let sessionConfiguration: URLSessionConfiguration
    lazy var session = URLSession(
        configuration: sessionConfiguration
    )

    enum Constants {
        // Taken from Alamofire.
        static let acceptableStatusCodes = 200 ..< 300
    }

    public init(sessionConfiguration: URLSessionConfiguration, clientInfo: ClientInfo) {
        self.sessionConfiguration = sessionConfiguration
        var headers = sessionConfiguration.httpAdditionalHeaders ?? [:]

        for (key, value) in clientInfo.asMap() {
            headers[key.rawValue] = value
        }
        sessionConfiguration.httpAdditionalHeaders = headers
    }

    private func request<Response>(
        _ request: URLRequest,
        transformer: @escaping (Data) throws -> Response,
        completion: @escaping (Result<Response, PlexError>) -> Void
    ) -> URLSessionTask? {
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse else {
                completion(.failure(
                    .networkError(request.url!, .httpError(error))
                ))
                return
            }

            guard Constants.acceptableStatusCodes.contains(response.statusCode) else {
                completion(.failure(
                    .networkError(request.url!, .unacceptableStatusCode(response.statusCode))
                ))
                return
            }

            do {
                completion(.success(try transformer(data)))
            } catch {
                completion(.failure(.decodingFailed(request.url!, error)))
            }
        }

        task.resume()

        return task
    }

    @discardableResult public func request<Request: PlexServiceRequest>(
        _ request: Request,
        token: String? = nil,
        completion: @escaping (Result<Request.Response, PlexError>) -> Void
    ) -> URLSessionTask? {
        let urlRequest: URLRequest

        do {
            urlRequest = try request.asURLRequest(using: token)
        } catch let error as PlexError {
            completion(.failure(error))
            return nil
        } catch {
            completion(.failure(.invalidRequest(.unknown(error))))
            return nil
        }

        return self.request(
            urlRequest,
            transformer: Request.response(from:),
            completion: completion
        )
    }

    @discardableResult public func request<Request: PlexResourceRequest>(
        _ request: Request,
        from url: URL,
        token: String? = nil,
        completion: @escaping (Result<Request.Response, PlexError>) -> Void
    ) -> URLSessionTask? {
        let urlRequest: URLRequest

        do {
            urlRequest = try request.asURLRequest(
                from: url,
                using: token
            )
        } catch let error as PlexError {
            completion(.failure(error))
            return nil
        } catch {
            completion(.failure(.invalidRequest(.unknown(error))))
            return nil
        }

        return self.request(
            urlRequest,
            transformer: Request.response(from:),
            completion: completion
        )
    }
}

// MARK: - Client Info.

public extension Plex {
    struct ClientInfo: Codable {
        public init(
            clientIdentifier: String,
            product: String? = nil,
            version: String? = nil,
            platform: String? = nil,
            platformVersion: String? = nil,
            device: String? = nil,
            deviceName: String? = nil,
            token: String? = nil,
            sessionIdentifier: String? = nil
        ) {
            self.clientIdentifier = clientIdentifier
            self.product = product
            self.version = version
            self.platform = platform
            self.platformVersion = platformVersion
            self.device = device
            self.deviceName = deviceName
            self.token = token
            self.sessionIdentifier = sessionIdentifier
        }

        /// Most requests require this key, so making it non-optional.
        public var clientIdentifier: String
        public var product: String?
        public var version: String?
        public var platform: String?
        public var platformVersion: String?
        public var device: String?
        public var deviceName: String?
        public var token: String?
        public var sessionIdentifier: String?

        public enum CodingKeys: String, CodingKey, CaseIterable {
            case clientIdentifier = "X-Plex-Client-Identifier"
            case product = "X-Plex-Product"
            case version = "X-Plex-Version"
            case platform = "X-Plex-Platform"
            case platformVersion = "X-Plex-Platform-Version"
            case device = "X-Plex-Device"
            case deviceName = "X-Plex-Device-Name"
            case token = "X-Plex-Token"
            case sessionIdentifier = "X-Plex-Session-Identifier"
        }

        func asMap() -> [CodingKeys: String] {
            let map: [CodingKeys: String?] = [
                .clientIdentifier: clientIdentifier,
                .product: product,
                .version: version,
                .platform: platform,
                .platformVersion: platformVersion,
                .device: device,
                .deviceName: deviceName,
                .token: token,
                .sessionIdentifier: sessionIdentifier,
            ]
            return map.compactMapValues { $0 }
        }
    }

    typealias Header = ClientInfo.CodingKeys
}

// MARK: - Namespaces.

public extension Plex {
    /// Namespace for `PlexConnectionRequest` implementations.
    enum Request {}

    /// Namespace for `PlexServiceRequest` implementations.
    enum ServiceRequest {}
}

// MARK: - Errors.

public enum PlexError: Error {
    /// An error occurred while constructing the request.
    case invalidRequest(RequestFailureReason)
    /// An networking error occurred.
    case networkError(URL, NetworkFailureReason)
    /// An error occurred while decoding the response.
    case decodingFailed(URL, Error)

    /// A token was not supplied for a request that required one.
    case notAuthenticated

    public enum RequestFailureReason {
        case invalidURL(String)
        case invalidQueryItems([URLQueryItem])
        case unknown(Error)
    }

    public enum NetworkFailureReason {
        case unacceptableStatusCode(Int)
        case httpError(Error?)
    }
}
