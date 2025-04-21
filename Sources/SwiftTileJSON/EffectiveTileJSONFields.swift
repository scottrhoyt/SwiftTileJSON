//
//  EffectiveTileJSONFields.swift
//  SwiftTileJSON
//
//  Created by Scott Hoyt on 4/21/25.
//

import Foundation

public protocol EffectiveTileJSONFields {
    /// The effective bounds with default applied if not specified.
    var effectiveBounds: [Double] { get }
    
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
    public struct Defaults {
        public static let bounds = [-180, -85.05112877980659, 180, 85.0511287798066]
        public static let maxZoom = 30
        public static let minZoom = 0
        public static let scheme = TileJSON.TileScheme.xyz
        public static let version = "1.0.0"
        public static let data = [String]()
        public static let grids = [String]()
    }
    
    public var effectiveBounds: [Double] { bounds ?? Defaults.bounds }
    public var effectiveMaxZoom: Int { maxZoom ?? Defaults.maxZoom }
    public var effectiveMinZoom: Int { minZoom ?? Defaults.minZoom }
    public var effectiveScheme: TileScheme { scheme ?? Defaults.scheme }
    public var effectiveVersion: String { version ?? Defaults.version }
    public var effectiveData: [String] { data ?? Defaults.data }
    public var effectiveGrids: [String] { grids ?? Defaults.grids }
}

extension CustomFieldsTileJSON: EffectiveTileJSONFields {
    public var effectiveBounds: [Double] { tileJSON.bounds ?? TileJSON.Defaults.bounds }
    public var effectiveMaxZoom: Int { tileJSON.maxZoom ?? TileJSON.Defaults.maxZoom }
    public var effectiveMinZoom: Int { tileJSON.minZoom ?? TileJSON.Defaults.minZoom }
    public var effectiveScheme: TileJSON.TileScheme { tileJSON.scheme ?? TileJSON.Defaults.scheme }
    public var effectiveVersion: String { tileJSON.version ?? TileJSON.Defaults.version }
    public var effectiveData: [String] { tileJSON.data ?? TileJSON.Defaults.data }
    public var effectiveGrids: [String] { tileJSON.grids ?? TileJSON.Defaults.grids }
}
