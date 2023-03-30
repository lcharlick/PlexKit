//
//  Publishers.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 14/6/2022.
//  Copyright © 2022 Lachlan Charlick. All rights reserved.
//

#if canImport(Combine)
import Foundation
import Combine

@available(OSX 10.15, iOS 13, tvOS 13, watchOS 6, *)
public extension Plex {
    /// Returns a publisher that tracks a `PlexServiceRequest`.
    /// The publisher publishes data when the task completes, or terminates if the task fails with an error.
    func publisher<Request: PlexServiceRequest>(_ request: Request, token: String? = nil) -> AnyPublisher<Request.Response, PlexError> {
        let urlRequest: URLRequest

        do {
            urlRequest = try request.asURLRequest(using: token)
        } catch let error as PlexError {
            return Combine.Fail(error: error).eraseToAnyPublisher()
        } catch {
            return Combine.Fail(error: .invalidRequest(.unknown(error))).eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: urlRequest).tryMap { data, response in
            guard let response = response as? HTTPURLResponse else {
                throw PlexError.networkError(urlRequest.url!, .httpError(nil))
            }

            guard Constants.acceptableStatusCodes.contains(response.statusCode) else {
                throw PlexError.networkError(urlRequest.url!, .unacceptableStatusCode(response.statusCode))
            }

            do {
                return try Request.response(from: data)
            } catch {
                throw PlexError.decodingFailed(urlRequest.url!, error)
            }
        }
        .mapError { error in
            if let plexError = error as? PlexError {
                return plexError
            }
            return .networkError(urlRequest.url!, .httpError(error))
        }
        .eraseToAnyPublisher()
    }

    /// Returns a publisher that tracks a `PlexResourceRequest`.
    /// The publisher publishes data when the task completes, or terminates if the task fails with an error.
    func publisher<Request: PlexResourceRequest>(_ request: Request, from url: URL, token: String? = nil) -> AnyPublisher<Request.Response, PlexError> {
        let urlRequest: URLRequest

        do {
            urlRequest = try request.asURLRequest(from: url, using: token)
        } catch let error as PlexError {
            return Combine.Fail(error: error).eraseToAnyPublisher()
        } catch {
            return Combine.Fail(error: .invalidRequest(.unknown(error))).eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: urlRequest).tryMap { data, response in
            guard let response = response as? HTTPURLResponse else {
                throw PlexError.networkError(urlRequest.url!, .httpError(nil))
            }

            guard Constants.acceptableStatusCodes.contains(response.statusCode) else {
                throw PlexError.networkError(urlRequest.url!, .unacceptableStatusCode(response.statusCode))
            }

            do {
                return try Request.response(from: data)
            } catch {
                throw PlexError.decodingFailed(urlRequest.url!, error)
            }
        }
        .mapError { error in
            if let plexError = error as? PlexError {
                return plexError
            }
            return .networkError(urlRequest.url!, .httpError(error))
        }
        .eraseToAnyPublisher()
    }
}
#endif
