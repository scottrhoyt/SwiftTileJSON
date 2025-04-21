//
//  TileJSONFields.swift
//  SwiftTileJSON
//
//  Created by Scott Hoyt on 4/21/25.
//

import Foundation

/// A protocol representing the required and optional fields of the TileJSON 3.0 spec.
public protocol TileJSONFields {
    /// REQUIRED. The version of the TileJSON spec that is implemented by this JSON object.
    var tilejson: String { get }
    
    /// REQUIRED. An array of tile endpoints. Must contain at least one endpoint.
    var tiles: [String] { get }
    
    /// REQUIRED for vector tiles, not required for other formats like raster tiles.
    /// An array of objects describing vector tile layers.
    var vectorLayers: [TileJSON.VectorLayer]? { get }
    
    /// OPTIONAL. Attribution to be displayed when the map is shown.
    var attribution: String? { get }
    
    /// OPTIONAL. The maximum extent of available map tiles in the format [left, bottom, right, top].
    /// Default: [-180, -85.05112877980659, 180, 85.0511287798066]
    var bounds: [Double]? { get }
    
    /// OPTIONAL. The default center position of the map in the format [longitude, latitude, zoom].
    var center: [Double]? { get }
    
    /// OPTIONAL. An array of GeoJSON data files. Default: []
    var data: [String]? { get }
    
    /// OPTIONAL. A text description of the tileset.
    var description: String? { get }
    
    /// OPTIONAL. An integer specifying the zoom level from which to generate overzoomed tiles.
    var fillzoom: Int? { get }
    
    /// OPTIONAL. An array of interactivity endpoints. Default: []
    var grids: [String]? { get }
    
    /// OPTIONAL. Contains a legend to be displayed with the map.
    var legend: String? { get }
    
    /// OPTIONAL. Maximum zoom level. Default: 30. Must be in range: 0 <= minZoom <= maxZoom <= 30.
    var maxZoom: Int? { get }
    
    /// OPTIONAL. Minimum zoom level. Default: 0. Must be in range: 0 <= minZoom <= maxZoom <= 30.
    var minZoom: Int? { get }
    
    /// OPTIONAL. A name describing the tileset.
    var name: String? { get }
    
    /// OPTIONAL. Either "xyz" or "tms". Default: "xyz"
    var scheme: TileJSON.TileScheme? { get }
    
    /// OPTIONAL. Contains a mustache template for interactivity formatting.
    var template: String? { get }
    
    /// OPTIONAL. A semver.org version number of the tileset. Default: "1.0.0"
    var version: String? { get }
}
