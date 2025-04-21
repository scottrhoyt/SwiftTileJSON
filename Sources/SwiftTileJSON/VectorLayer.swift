//
//  VectorLayer.swift
//  SwiftTileJSON
//
//  Created by Scott Hoyt on 4/20/25.
//

import Foundation

/// Describes one layer of vector tile data
struct VectorLayer: Codable {
    /// REQUIRED. A string value representing the layer id.
    let id: String
    
    /// REQUIRED. An object whose keys and values are the names and descriptions of attributes.
    /// If no fields are present, it should be an empty object.
    let fields: [String: String]
    
    /// OPTIONAL. A human-readable description of the layer.
    let description: String?
    
    /// OPTIONAL. The lowest zoom level whose tiles this layer appears in.
    let minzoom: Int?
    
    /// OPTIONAL. The highest zoom level whose tiles this layer appears in.
    let maxzoom: Int?
}
