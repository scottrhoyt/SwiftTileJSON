//
//  TileJSON+VectorLayer.swift
//  SwiftTileJSON
//
//  Created by Scott Hoyt on 4/21/25.
//

import Foundation

public extension TileJSON {
    /// Describes one layer of vector tile data
    struct VectorLayer: Codable, Equatable, Hashable, Sendable {
        /// REQUIRED. A string value representing the layer id.
        public let id: String
        
        /// REQUIRED. An object whose keys and values are the names and descriptions of attributes.
        /// If no fields are present, it should be an empty object.
        public let fields: [String: String]
        
        /// OPTIONAL. A human-readable description of the layer.
        public let description: String?
        
        /// OPTIONAL. The lowest zoom level whose tiles this layer appears in. `maxzoom` in the spec.
        public internal(set) var minZoom: Int?
        
        /// OPTIONAL. The highest zoom level whose tiles this layer appears in. `minzoom` in the spec.
        public internal(set) var maxZoom: Int?
        
        /// Initialize a new ``VectorLayer``
        /// - Parameters:
        ///   - id: The layer id
        ///   - fields: The fields available in the layer and their descriptions
        ///   - description: A description of the layer. Default `nil`.
        ///   - minZoom: The minimum zoom of the layer. Default `nil`.
        ///   - maxZoom: The maximum zoom of the layer. Default `nil`.
        public init(id: String, fields: [String : String], description: String? = nil, minZoom: Int? = nil, maxZoom: Int? = nil) {
            self.id = id
            self.fields = fields
            self.description = description
            self.minZoom = minZoom
            self.maxZoom = maxZoom
        }
        
        // MARK: Coding Keys
        
        internal enum CodingKeys: String, CodingKey {
            case id
            case fields
            case description
            case minZoom = "minzoom"
            case maxZoom = "maxzoom"
        }
        
        // MARK: Custom Decoding
        
        /// Decodes a ``VectorLayer`` from a dictionary representation.
        ///
        /// - Throws: A ``DecodingError`` if the required `id` and `fields` properties are not present.
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            // Decode REQUIRED fields.
            id = try container.decode(String.self, forKey: TileJSON.VectorLayer.CodingKeys.id)
            fields = try container.decode([String : String].self, forKey: TileJSON.VectorLayer.CodingKeys.fields)
            
            // Decode OPTIONAL fields, ignoring if invalid.
            description = try? container.decodeIfPresent(String.self, forKey: TileJSON.VectorLayer.CodingKeys.description)
            (minZoom, maxZoom) = Valid.zoomLevels(
                minZoom: try? container.decodeIfPresent(Int.self, forKey: TileJSON.VectorLayer.CodingKeys.minZoom),
                maxZoom: try? container.decodeIfPresent(Int.self, forKey: TileJSON.VectorLayer.CodingKeys.maxZoom)
            )
        }
    }
}
