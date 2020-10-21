//
//  Util.swift
//  PlexKitTests
//
//  Created by Lachlan Charlick on 29/5/20.
//  Copyright © 2020 Lachlan Charlick. All rights reserved.
//

import Foundation

class BundleLocator {}

func loadResource(_ name: String, ext: String) throws -> Data {
    guard let path = Bundle.module.path(forResource: name, ofType: ext) else {
        throw ResourceNotFoundError(name: name, ext: ext)
    }
    return try Data(contentsOf: URL(fileURLWithPath: path))
}

func urlForFile(_ name: String, ext: String) -> URL {
    let bundle = Bundle(for: BundleLocator.self)
    return bundle.url(forResource: name, withExtension: ext)!
}

struct ResourceNotFoundError: Error {
    let name: String
    let ext: String
}
