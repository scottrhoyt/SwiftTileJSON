//
//  TileJSON.swift
//  SwiftTileJSON
//
//  Created by Scott Hoyt on 4/20/25.
//

import Foundation
import Version

/// A Swift model for [TileJSON 3.0.0 specification](https://github.com/mapbox/tilejson-spec/blob/master/3.0.0/example/osm.json).
///
/// TileJSON is a format used to represent metadata about multiple types of web-based map layers.
public struct TileJSON: TileJSONFields, Equatable, Hashable {
    /// REQUIRED. The version of the TileJSON spec that is implemented by this JSON object. `tilejson` in the spec.
    public let tileJSONVersion: Version
    
    /// REQUIRED. An array of tile endpoints. Must contain at least one endpoint.
    public let tiles: [String]
    
    /// REQUIRED for vector tiles, not required for other formats like raster tiles.
    /// An array of objects describing vector tile layers.
    public let vectorLayers: [VectorLayer]?
    
    /// OPTIONAL. Attribution to be displayed when the map is shown.
    public let attribution: String?
    
    /// OPTIONAL. The maximum extent of available map tiles in the format [left, bottom, right, top].
    /// Default: [-180, -85.05112877980659, 180, 85.0511287798066]
    public let bounds: Bounds?
    
    /// OPTIONAL. The default center position of the map in the format [longitude, latitude, zoom].
    public let center: Center?
    
    /// OPTIONAL. An array of GeoJSON data files. Default: []
    public let data: [String]?
    
    /// OPTIONAL. A text description of the tileset.
    public let description: String?
    
    /// OPTIONAL. An integer specifying the zoom level from which to generate overzoomed tiles. `fillzoom` in the spec.
    public let fillZoom: Int?
    
    /// OPTIONAL. An array of interactivity endpoints. Default: []
    public let grids: [String]?
    
    /// OPTIONAL. Contains a legend to be displayed with the map.
    public let legend: String?
    
    /// OPTIONAL. Maximum zoom level. Default: 30. Must be in range: 0 <= minZoom <= maxZoom <= 30. `maxzoom` in the spec.
    public let maxZoom: Int?
    
    /// OPTIONAL. Minimum zoom level. Default: 0. Must be in range: 0 <= minZoom <= maxZoom <= 30. `minzoom` in the spec.
    public let minZoom: Int?
    
    /// OPTIONAL. A name describing the tileset.
    public let name: String?
    
    /// OPTIONAL. Either "xyz" or "tms". Default: "xyz"
    public let scheme: TileScheme?
    
    /// OPTIONAL. Contains a mustache template for interactivity formatting.
    public let template: String?
    
    /// OPTIONAL. A semver.org version number of the tileset. Default: "1.0.0"
    public let version: Version?
    
    public init(
        tileJSONVersion: Version = Version(3, 0, 0),
        tiles: [String],
        vectorLayers: [VectorLayer]? = nil,
        attribution: String? = nil,
        bounds: Bounds? = nil,
        center: Center? = nil,
        data: [String]? = nil,
        description: String? = nil,
        fillZoom: Int? = nil,
        grids: [String]? = nil,
        legend: String? = nil,
        maxZoom: Int? = nil,
        minZoom: Int? = nil,
        name: String? = nil,
        scheme: TileScheme? = nil,
        template: String? = nil,
        version: Version? = nil
    ) {
        self.tileJSONVersion = tileJSONVersion
        self.tiles = tiles
        self.vectorLayers = vectorLayers
        self.attribution = attribution
        self.bounds = bounds
        self.center = center
        self.data = data
        self.description = description
        self.fillZoom = fillZoom
        self.grids = grids
        self.legend = legend
        self.maxZoom = maxZoom
        self.minZoom = minZoom
        self.name = name
        self.scheme = scheme
        self.template = template
        self.version = version
    }
}

// MARK: - Custom Codable

extension TileJSON: Codable {
    enum CodingKeys: String, CodingKey, CaseIterable {
        case tileJSONVersion = "tilejson"
        case tiles
        case vectorLayers = "vector_layers"
        case attribution
        case bounds
        case center
        case data
        case description
        case fillZoom = "fillzoom"
        case grids
        case legend
        case maxZoom = "maxzoom"
        case minZoom = "minzoom"
        case name
        case scheme
        case template
        case version
    }
    
    /// Custom initializer to validate TileJSON data during decoding
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode REQUIRED fields.
        tileJSONVersion = try container.decode(Version.self, forKey: .tileJSONVersion)
        tiles = try container.decode([String].self, forKey: .tiles)
        
        // Validate compatible TileJSON version
        guard Valid.tileJSONVersion(tileJSONVersion) else {
            throw DecodingError.typeMismatch(
                String.self,
                DecodingError.Context(
                    codingPath: [CodingKeys.tileJSONVersion],
                    debugDescription: "Only TileJSON v3.x.x is supported"
                )
            )
        }
        
        // Validate tiles array is not empty (REQUIRED by spec)
        guard !tiles.isEmpty else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: [CodingKeys.tiles],
                    debugDescription: "TileJSON requires at least one tile endpoint."
                )
            )
        }
        
        // Decode OPTIONAL fields, ignoring if invalid.
        bounds = try? container.decodeIfPresent(Bounds.self, forKey: .bounds)
        attribution = try? container.decodeIfPresent(String.self, forKey: .attribution)
        data = try? container.decodeIfPresent([String].self, forKey: .data)
        description = try? container.decodeIfPresent(String.self, forKey: .description)
        fillZoom = try? container.decodeIfPresent(Int.self, forKey: .fillZoom)
        grids = try? container.decodeIfPresent([String].self, forKey: .grids)
        legend = try? container.decodeIfPresent(String.self, forKey: .legend)
        name = try? container.decodeIfPresent(String.self, forKey: .name)
        scheme = try? container.decodeIfPresent(TileScheme.self, forKey: .scheme)
        template = try? container.decodeIfPresent(String.self, forKey: .template)
        version = try? container.decodeIfPresent(Version.self, forKey: .version)
        
        // Decode OPTIONAL zoom levels. `nil` if invalid.
        (minZoom, maxZoom) = Valid.zoomLevels(
            minZoom: try? container.decodeIfPresent(Int.self, forKey: .minZoom),
            maxZoom: try? container.decodeIfPresent(Int.self, forKey: .maxZoom)
        )
        
        // Decode OPTIONAL vector_layers. `nil` if invalid.
        if let potentialVectorLayers = try? container.decodeIfPresent([VectorLayer].self, forKey: .vectorLayers) {
            vectorLayers = potentialVectorLayers.map { [minZoom, maxZoom] in Valid.vectorLayer($0, minZoom: minZoom, maxZoom: maxZoom) }
        } else {
            vectorLayers = nil
        }
        
        // Decode OPTIONAL center. `nil` in invalid.
        center = Valid.center(
            try? container.decodeIfPresent(Center.self, forKey: .center),
            minZoom: minZoom,
            maxZoom: maxZoom,
            bounds: bounds
        )
    }
}
