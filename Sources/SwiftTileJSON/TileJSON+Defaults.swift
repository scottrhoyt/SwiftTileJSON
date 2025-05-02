//
//  TileJSON+Defaults.swift
//  SwiftTileJSON
//
//  Created by Scott Hoyt on 4/21/25.
//

import Foundation
import Version

extension TileJSON {
    struct Defaults {
        static let bounds = Bounds(
            minLongitude: -180,
            minLatitude: -85.05112877980659,
            maxLongitude: 180,
            maxLatitude: 85.0511287798066
        )
        static let maxZoom = 30
        static let minZoom = 0
        static let scheme = TileJSON.TileScheme.xyz
        static let version = Version(1, 0, 0)
        static let data = [String]()
        static let grids = [String]()
    }
}
