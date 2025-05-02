//
//  TileJSONFields.swift
//  SwiftTileJSON
//
//  Created by Scott Hoyt on 4/21/25.
//

import Foundation
import Version

/// A protocol representing the required and optional fields of the TileJSON 3.0 spec.
public protocol TileJSONFields {
    /// REQUIRED. The version of the TileJSON spec that is implemented by this JSON object. `tilejson` in the spec.
    var tileJSON: Version { get }
    
    /// REQUIRED. An array of tile endpoints. Must contain at least one endpoint.
    var tiles: [String] { get }
    
    /// REQUIRED for vector tiles, not required for other formats like raster tiles.
    /// An array of objects describing vector tile layers.
    var vectorLayers: [TileJSON.VectorLayer]? { get }
    
    /// OPTIONAL. Attribution to be displayed when the map is shown.
    var attribution: String? { get }
    
    /// OPTIONAL. The maximum extent of available map tiles in the format [left, bottom, right, top].
    /// Default: [-180, -85.05112877980659, 180, 85.0511287798066]
    var bounds: TileJSON.Bounds? { get }
    
    /// OPTIONAL. The default center position of the map in the format [longitude, latitude, zoom].
    var center: TileJSON.Center? { get }
    
    /// OPTIONAL. An array of GeoJSON data files. Default: []
    var data: [String]? { get }
    
    /// OPTIONAL. A text description of the tileset.
    var description: String? { get }
    
    /// OPTIONAL. An integer specifying the zoom level from which to generate overzoomed tiles. `fillzoom` in the spec.
    var fillZoom: Int? { get }
    
    /// OPTIONAL. An array of interactivity endpoints. Default: []
    var grids: [String]? { get }
    
    /// OPTIONAL. Contains a legend to be displayed with the map.
    var legend: String? { get }
    
    /// OPTIONAL. Maximum zoom level. Default: 30. Must be in range: 0 <= minZoom <= maxZoom <= 30. `maxzoom` in the spec.
    var maxZoom: Int? { get }
    
    /// OPTIONAL. Minimum zoom level. Default: 0. Must be in range: 0 <= minZoom <= maxZoom <= 30. `minzoom` in the spec.
    var minZoom: Int? { get }
    
    /// OPTIONAL. A name describing the tileset.
    var name: String? { get }
    
    /// OPTIONAL. Either "xyz" or "tms". Default: "xyz"
    var scheme: TileJSON.TileScheme? { get }
    
    /// OPTIONAL. Contains a mustache template for interactivity formatting.
    var template: String? { get }
    
    /// OPTIONAL. A semver.org version number of the tileset. Default: "1.0.0"
    var version: Version? { get }
    
    // MARK: Effective Fields
    
    /// The effective bounds with default applied if not specified.
    var effectiveBounds: TileJSON.Bounds { get }
    
    /// The effective maximum zoom level with default applied if not specified.
    var effectiveMaxZoom: Int { get }
    
    /// The effective minimum zoom level with default applied if not specified.
    var effectiveMinZoom: Int { get }
    
    /// The effective tile schema with default applied if not specified.
    var effectiveScheme: TileJSON.TileScheme { get }
    
    /// The effective version with default applied if not specified.
    var effectiveVersion: Version { get }
    
    /// The effective data array with default applied if not specified.
    var effectiveData: [String] { get }
    
    /// The effective grids array with default applied if not specified.
    var effectiveGrids: [String] { get }
}

// MARK: - Default effective fields implementation

extension TileJSONFields {
    public var effectiveBounds: TileJSON.Bounds { bounds ?? TileJSON.Defaults.bounds }
    public var effectiveMaxZoom: Int { maxZoom ?? TileJSON.Defaults.maxZoom }
    public var effectiveMinZoom: Int { minZoom ?? TileJSON.Defaults.minZoom }
    public var effectiveScheme: TileJSON.TileScheme { scheme ?? TileJSON.Defaults.scheme }
    public var effectiveVersion: Version { version ?? TileJSON.Defaults.version }
    public var effectiveData: [String] { data ?? TileJSON.Defaults.data }
    public var effectiveGrids: [String] { grids ?? TileJSON.Defaults.grids }
}
