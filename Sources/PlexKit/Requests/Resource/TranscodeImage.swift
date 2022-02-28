//
//  TranscodeImage.swift
//  PlexKit
//
//  Created by Lachlan Charlick on 31/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import CoreGraphics
import Foundation

public extension Plex.Request {
    struct TranscodeImage: PlexResourceRequest {
        public let path = "photo/:/transcode"
        public let accept = "image/*"

        public var queryItems: [URLQueryItem]? {
            var items: [URLQueryItem] = [
                .init(name: "url", value: key),
                .init(name: "minSize", value: minSize),
            ]

            if let size = size {
                items.append(contentsOf: [
                    .init(name: "width", value: Int(ceil(size.width))),
                    .init(name: "height", value: Int(ceil(size.height))),
                ])
            }

            if let blur = blur {
                items.append(
                    .init(name: "blur", value: blur)
                )
            }

            if let saturation = saturation {
                items.append(
                    .init(name: "saturation", value: saturation)
                )
            }

            if let opacity = opacity {
                items.append(
                    .init(name: "opacity", value: opacity)
                )
            }

            return items
        }

        /// The path to the image.
        /// - SeeAlso: `thumb` property of `MediaItem`.
        private let key: String

        /// The dimensions of the result image.
        private let size: CGSize?

        /// Whether to resize according to the image's smallest
        /// dimension.
        private let minSize: Bool

        /// Blur radius 0...200
        private let blur: Int?

        /// Saturation intensity 0...100
        private let saturation: Int?

        /// Opacity 0...100
        private let opacity: Int?

        public init(
            key: String,
            size: CGSize? = nil,
            minSize: Bool = true,
            blur: Int? = nil,
            saturation: Int? = nil,
            opacity: Int? = nil
        ) {
            self.key = key
            self.size = size
            self.minSize = minSize
            self.blur = blur
            self.saturation = saturation
            self.opacity = opacity
        }

        public static func response(from data: Data) throws -> Data {
            data
        }
    }
}
