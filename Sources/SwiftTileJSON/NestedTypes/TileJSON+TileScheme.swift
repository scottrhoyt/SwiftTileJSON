//
//  TileJSON+TileScheme.swift
//  SwiftTileJSON
//
//  Created by Scott Hoyt on 4/21/25.
//

import Foundation

public extension TileJSON {
    /// The schema for the tile coordinates
    enum TileScheme: String, Codable, Sendable {
        case xyz = "xyz"
        case tms = "tms"
    }
}
