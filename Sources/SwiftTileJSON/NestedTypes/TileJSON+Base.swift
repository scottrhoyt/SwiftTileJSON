//
//  TileJSON+Base.swift
//  SwiftTileJSON
//
//  Created by Scott Hoyt on 4/20/25.
//

import Foundation
import Version

extension TileJSON {
    /// A Swift model for base fields of the [TileJSON 3.0.0 specification](https://github.com/mapbox/tilejson-spec/tree/master/3.0.0).
    ///
    /// TileJSON is a format used to represent metadata about multiple types of web-based map layers.
    public struct Base: TileJSONFields, Equatable, Hashable, Codable, Sendable {
        public let tileJSON: Version
        public let tiles: [String]
        public let vectorLayers: [VectorLayer]?
        public let attribution: String?
        public let bounds: Bounds?
        public let center: Center?
        public let data: [String]?
        public let description: String?
        public let fillZoom: Int?
        public let grids: [String]?
        public let legend: String?
        public let maxZoom: Int?
        public let minZoom: Int?
        public let name: String?
        public let scheme: TileScheme?
        public let template: String?
        public let version: Version?
        
        public init(
            tileJSON: Version = Version(3, 0, 0),
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
            self.tileJSON = tileJSON
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
        
        // MARK: - Custom Codable
        
        enum CodingKeys: String, CodingKey, CaseIterable {
            case tileJSON = "tilejson"
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
            tileJSON = try container.decode(Version.self, forKey: .tileJSON)
            tiles = try container.decode([String].self, forKey: .tiles)
            
            // Validate compatible TileJSON version
            guard Valid.tileJSON(tileJSON) else {
                throw DecodingError.typeMismatch(
                    String.self,
                    DecodingError.Context(
                        codingPath: [CodingKeys.tileJSON],
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
}
