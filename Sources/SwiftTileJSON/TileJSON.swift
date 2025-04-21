//
//  TileJSON.swift
//  SwiftTileJSON
//
//  Created by Scott Hoyt on 4/20/25.
//

import Foundation

/// A Swift model for TileJSON 3.0.0 specification.
/// TileJSON is a format used to represent metadata about multiple types of web-based map layers.
public struct TileJSON: TileJSONFields, Codable, Equatable, Hashable {
    // TODO: Verify that this is TileJSON 3.0, fix initializer
    /// REQUIRED. The version of the TileJSON spec that is implemented by this JSON object.
    public let tilejson: String
    
    /// REQUIRED. An array of tile endpoints. Must contain at least one endpoint.
    public let tiles: [String]
    
    /// REQUIRED for vector tiles, not required for other formats like raster tiles.
    /// An array of objects describing vector tile layers.
    public let vectorLayers: [VectorLayer]?
    
    /// OPTIONAL. Attribution to be displayed when the map is shown.
    public let attribution: String?
    
    /// OPTIONAL. The maximum extent of available map tiles in the format [left, bottom, right, top].
    /// Default: [-180, -85.05112877980659, 180, 85.0511287798066]
    public let bounds: [Double]?
    
    /// OPTIONAL. The default center position of the map in the format [longitude, latitude, zoom].
    public let center: [Double]?
    
    /// OPTIONAL. An array of GeoJSON data files. Default: []
    public let data: [String]?
    
    /// OPTIONAL. A text description of the tileset.
    public let description: String?
    
    /// OPTIONAL. An integer specifying the zoom level from which to generate overzoomed tiles.
    public let fillzoom: Int?
    
    /// OPTIONAL. An array of interactivity endpoints. Default: []
    public let grids: [String]?
    
    /// OPTIONAL. Contains a legend to be displayed with the map.
    public let legend: String?
    
    /// OPTIONAL. Maximum zoom level. Default: 30. Must be in range: 0 <= minZoom <= maxZoom <= 30.
    public let maxZoom: Int?
    
    /// OPTIONAL. Minimum zoom level. Default: 0. Must be in range: 0 <= minZoom <= maxZoom <= 30.
    public let minZoom: Int?
    
    /// OPTIONAL. A name describing the tileset.
    public let name: String?
    
    /// OPTIONAL. Either "xyz" or "tms". Default: "xyz"
    public let scheme: TileScheme?
    
    /// OPTIONAL. Contains a mustache template for interactivity formatting.
    public let template: String?
    
    /// OPTIONAL. A semver.org version number of the tileset. Default: "1.0.0"
    public let version: String?
    
    // MARK: - Nested Types
    
    /// The schema for the tile coordinates
    public enum TileScheme: String, Codable {
        case xyz = "xyz"
        case tms = "tms"
    }
    
    /// Describes one layer of vector tile data
    public struct VectorLayer: Codable, Equatable, Hashable {
        /// REQUIRED. A string value representing the layer id.
        public let id: String
        
        /// REQUIRED. An object whose keys and values are the names and descriptions of attributes.
        /// If no fields are present, it should be an empty object.
        public let fields: [String: String]
        
        /// OPTIONAL. A human-readable description of the layer.
        public let description: String?
        
        /// OPTIONAL. The lowest zoom level whose tiles this layer appears in.
        public let minzoom: Int?
        
        /// OPTIONAL. The highest zoom level whose tiles this layer appears in.
        public let maxZoom: Int?
        
        /// Initialize a new `VectorLayer`
        /// - Parameters:
        ///   - id: The layer id
        ///   - fields: The fields available in the layer and their descriptions
        ///   - description: A description of the layer. Default `nil`.
        ///   - minzoom: The minimum zoom of the layer. Default `nil`.
        ///   - maxzoom: The maximum zoom of the layer. Default `nil`.
        public init(id: String, fields: [String : String], description: String? = nil, minzoom: Int? = nil, maxZoom: Int? = nil) {
            self.id = id
            self.fields = fields
            self.description = description
            self.minzoom = minzoom
            self.maxZoom = maxZoom
        }
        
        // MARK: Coding Keys
        internal enum CodingKeys: String, CodingKey {
            case id
            case fields
            case description
            case minzoom
            case maxZoom = "maxzoom"
        }
    }
    
    // MARK: - CodingKeys
    
    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case tilejson
        case tiles
        case vectorLayers = "vector_layers"
        case attribution
        case bounds
        case center
        case data
        case description
        case fillzoom
        case grids
        case legend
        case maxZoom = "maxzoom"
        case minZoom = "minzoom"
        case name
        case scheme
        case template
        case version
    }
    
    // MARK: - Computed Properties (Default Values)
    
    /// The effective bounds with default applied if not specified.
    var effectiveBounds: [Double] {
        return bounds ?? [-180, -85.05112877980659, 180, 85.0511287798066]
    }
    
    /// The effective maximum zoom level with default applied if not specified.
    var effectiveMaxzoom: Int {
        return maxZoom ?? 30
    }
    
    /// The effective minimum zoom level with default applied if not specified.
    var effectiveMinzoom: Int {
        return minZoom ?? 0
    }
    
    /// The effective tile schema with default applied if not specified.
    var effectiveScheme: TileScheme {
        return scheme ?? .xyz
    }
    
    /// The effective version with default applied if not specified.
    var effectiveVersion: String {
        return version ?? "1.0.0"
    }
    
    /// The effective data array with default applied if not specified.
    var effectiveData: [String] {
        return data ?? []
    }
    
    /// The effective grids array with default applied if not specified.
    var effectiveGrids: [String] {
        return grids ?? []
    }
    
    public init(
        tilejson: String = "3.0.0",
        tiles: [String],
        vectorLayers: [TileJSON.VectorLayer]? = nil,
        attribution: String? = nil,
        bounds: [Double]? = nil,
        center: [Double]? = nil,
        data: [String]? = nil,
        description: String? = nil,
        fillzoom: Int? = nil,
        grids: [String]? = nil,
        legend: String? = nil,
        maxZoom: Int? = nil,
        minZoom: Int? = nil,
        name: String? = nil,
        scheme: TileJSON.TileScheme? = nil,
        template: String? = nil,
        version: String? = nil
    ) {
        self.tilejson = tilejson
        self.tiles = tiles
        self.vectorLayers = vectorLayers
        self.attribution = attribution
        self.bounds = bounds
        self.center = center
        self.data = data
        self.description = description
        self.fillzoom = fillzoom
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

// MARK: - Custom Decoding

extension TileJSON {
    /// Custom initializer to validate TileJSON data during decoding
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode REQUIRED fields
        tilejson = try container.decode(String.self, forKey: .tilejson)
        tiles = try container.decode([String].self, forKey: .tiles)
        
        // Validate compatible TileJSON version
        if TileJSON.isValid(tileJsonVersion: tilejson) == false {
            throw DecodingError.typeMismatch(
                String.self,
                DecodingError.Context(
                    codingPath: [CodingKeys.tilejson],
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
        
        // Decode OPTIONAL fields
        vectorLayers = try container.decodeIfPresent([VectorLayer].self, forKey: .vectorLayers)
        attribution = try container.decodeIfPresent(String.self, forKey: .attribution)
        bounds = try container.decodeIfPresent([Double].self, forKey: .bounds)
        center = try container.decodeIfPresent([Double].self, forKey: .center)
        data = try container.decodeIfPresent([String].self, forKey: .data)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        fillzoom = try container.decodeIfPresent(Int.self, forKey: .fillzoom)
        grids = try container.decodeIfPresent([String].self, forKey: .grids)
        legend = try container.decodeIfPresent(String.self, forKey: .legend)
        maxZoom = try container.decodeIfPresent(Int.self, forKey: .maxZoom)
        minZoom = try container.decodeIfPresent(Int.self, forKey: .minZoom)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        scheme = try container.decodeIfPresent(TileScheme.self, forKey: .scheme)
        template = try container.decodeIfPresent(String.self, forKey: .template)
        version = try container.decodeIfPresent(String.self, forKey: .version)
        
        // Validate bounds if present
        if let bounds = bounds {
            guard bounds.count == 4 else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: [CodingKeys.bounds],
                        debugDescription: "TileJSON requires bounds to have exactly 4 elements [left, bottom, right, top]."
                    )
                )
            }
            
            let minLon = bounds[0]
            let minLat = bounds[1]
            let maxLon = bounds[2]
            let maxLat = bounds[3]
            
            // Validate longitude and latitude are in valid ranges
            guard minLon >= -180 && minLon <= 180 && 
                  maxLon >= -180 && maxLon <= 180 &&
                  minLat >= -90 && minLat <= 90 &&
                  maxLat >= -90 && maxLat <= 90 else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: [CodingKeys.bounds],
                        debugDescription: "TileJSON requires bounds longitude in [-180, 180] and latitude in [-90, 90]."
                    )
                )
            }
        }
        
        // Validate center if present
        if let center = center {
            guard center.count == 3 else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: [CodingKeys.center],
                        debugDescription: "TileJSON requires center to have exactly 3 elements [longitude, latitude, zoom]."
                    )
                )
            }
            
            let lon = center[0]
            let lat = center[1]
            let zoom = center[2]
            
            // Validate longitude, latitude, and zoom are in valid ranges
            guard lon >= -180 && lon <= 180 &&
                  lat >= -90 && lat <= 90 &&
                  zoom >= 0 && zoom <= 30 else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: [CodingKeys.center],
                        debugDescription: "TileJSON requires center longitude in [-180, 180], latitude in [-90, 90], and zoom in [0, 30]."
                    )
                )
            }
            
            // If bounds are specified, validate center is within bounds
            if let bounds = bounds {
                let minLon = bounds[0]
                let minLat = bounds[1]
                let maxLon = bounds[2]
                let maxLat = bounds[3]
                
                guard lon >= minLon && lon <= maxLon &&
                      lat >= minLat && lat <= maxLat else {
                    throw DecodingError.dataCorrupted(
                        DecodingError.Context(
                            codingPath: [CodingKeys.center, CodingKeys.bounds],
                            debugDescription: "TileJSON requires center to be within the specified bounds."
                        )
                    )
                }
            }
            
            // If minZoom and maxZoom are specified, validate zoom is within range
            if let minZoom = minZoom, let maxZoom = maxZoom {
                guard zoom >= Double(minZoom) && zoom <= Double(maxZoom) else {
                    throw DecodingError.dataCorrupted(
                        DecodingError.Context(
                            codingPath: [CodingKeys.center, CodingKeys.minZoom, CodingKeys.maxZoom],
                            debugDescription: "TileJSON requires center zoom to be between minZoom and maxZoom."
                        )
                    )
                }
            }
        }
        
        // Validate zoom levels if present
        if let minZoom = minZoom, let maxZoom = maxZoom {
            guard minZoom >= 0 && maxZoom >= 0 && minZoom <= maxZoom && maxZoom <= 30 else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: [CodingKeys.minZoom, CodingKeys.maxZoom],
                        debugDescription: "TileJSON requires 0 <= minZoom <= maxZoom <= 30."
                    )
                )
            }
        } else if let minZoom = minZoom {
            guard minZoom >= 0 && minZoom <= 30 else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: [CodingKeys.minZoom],
                        debugDescription: "TileJSON requires minZoom in range [0, 30]."
                    )
                )
            }
        } else if let maxZoom = maxZoom {
            guard maxZoom >= 0 && maxZoom <= 30 else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: [CodingKeys.maxZoom],
                        debugDescription: "TileJSON requires maxZoom in range [0, 30]."
                    )
                )
            }
        }
    }
    
    private static func isValid(tileJsonVersion: String) -> Bool {
        let versionParts = tileJsonVersion.split(separator: ".")
        
        if versionParts.count < 1 {
            return false
        }
        
        if let majorVersion = Int(versionParts[0]), majorVersion == 3 {
            return true
        }
        
        return false
    }
}

// MARK: - Utilities

extension TileJSON {
    /// Creates a JSONDecoder configured for TileJSON
    static func createDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }
    
    /// Decode a TileJSON object from JSON data
    static func decode(from data: Data) throws -> TileJSON {
        let decoder = createDecoder()
        return try decoder.decode(TileJSON.self, from: data)
    }
    
    /// Decode a TileJSON object from a JSON string
    static func decode(from jsonString: String) throws -> TileJSON? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        return try decode(from: data)
    }
}
