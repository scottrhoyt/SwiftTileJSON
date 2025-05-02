//
//  EffectiveTileJSONFields.swift
//  SwiftTileJSON
//
//  Created by Scott Hoyt on 4/21/25.
//

import Foundation

/// A protocol that specifies fields that override missing or invalid TileJSON fields
/// with their default values from the TileJSON spec.
public protocol EffectiveTileJSONFields {
    /// The effective bounds with default applied if not specified.
    var effectiveBounds: TileJSON.Bounds { get }
    
    /// The effective maximum zoom level with default applied if not specified.
    var effectiveMaxZoom: Int { get }
    
    /// The effective minimum zoom level with default applied if not specified.
    var effectiveMinZoom: Int { get }
    
    /// The effective tile schema with default applied if not specified.
    var effectiveScheme: TileJSON.TileScheme { get }
    
    /// The effective version with default applied if not specified.
    var effectiveVersion: String { get }
    
    /// The effective data array with default applied if not specified.
    var effectiveData: [String] { get }
    
    /// The effective grids array with default applied if not specified.
    var effectiveGrids: [String] { get }
}

extension TileJSON: EffectiveTileJSONFields {
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
        static let version = "1.0.0"
        static let data = [String]()
        static let grids = [String]()
    }
    
    public var effectiveBounds: Bounds { bounds ?? Defaults.bounds }
    public var effectiveMaxZoom: Int { maxZoom ?? Defaults.maxZoom }
    public var effectiveMinZoom: Int { minZoom ?? Defaults.minZoom }
    public var effectiveScheme: TileScheme { scheme ?? Defaults.scheme }
    public var effectiveVersion: String { version ?? Defaults.version }
    public var effectiveData: [String] { data ?? Defaults.data }
    public var effectiveGrids: [String] { grids ?? Defaults.grids }
}

extension ExtendedTileJSON: EffectiveTileJSONFields {
    public var effectiveBounds: TileJSON.Bounds { tileJSON.bounds ?? TileJSON.Defaults.bounds }
    public var effectiveMaxZoom: Int { tileJSON.maxZoom ?? TileJSON.Defaults.maxZoom }
    public var effectiveMinZoom: Int { tileJSON.minZoom ?? TileJSON.Defaults.minZoom }
    public var effectiveScheme: TileJSON.TileScheme { tileJSON.scheme ?? TileJSON.Defaults.scheme }
    public var effectiveVersion: String { tileJSON.version ?? TileJSON.Defaults.version }
    public var effectiveData: [String] { tileJSON.data ?? TileJSON.Defaults.data }
    public var effectiveGrids: [String] { tileJSON.grids ?? TileJSON.Defaults.grids }
}
