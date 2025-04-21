//
//  CustomFieldsTileJSON.swift
//  SwiftTileJSON
//
//  Created by Scott Hoyt on 4/21/25.
//

import Foundation

/// A wrapper for handling arbitrary fields in a TileJSON object
public struct CustomFieldsTileJSON: TileJSONFields, Codable {
    /// The underlying `TileJSON` object
    public let tileJSON: TileJSON
    
    /// Additional fields not handled by the TileJSON spec
    public let customFields: [String: Any]?
    
    /// Create a new `CustomFieldsTileJSON` object
    /// - Parameters:
    ///   - tileJSON: The object conforming to the TileJSON 3.0 spec
    ///   - customFields: A dictionary of custom fields for encoding/decoding. `nil` by default.
    public init(tileJSON: TileJSON, customFields: [String: Any]? = nil) {
        self.tileJSON = tileJSON
        self.customFields = customFields
    }
    
    // MARK: TileJSONFields
    
    public var tilejson: String { tileJSON.tilejson } // TODO: Rename tilejson to tileJsonVersion
    public var tiles: [String] { tileJSON.tiles }
    public var vectorLayers: [TileJSON.VectorLayer]? { tileJSON.vectorLayers }
    public var attribution: String? { tileJSON.attribution }
    public var bounds: [Double]? { tileJSON.bounds }
    public var center: [Double]? { tileJSON.center }
    public var data: [String]? { tileJSON.data }
    public var description: String? {tileJSON.description }
    public var fillzoom: Int? { tileJSON.fillzoom }
    public var grids: [String]? { tileJSON.grids }
    public var legend: String? { tileJSON.legend }
    public var maxZoom: Int? { tileJSON.maxZoom }
    public var minZoom: Int? { tileJSON.minZoom }
    public var name: String? { tileJSON.name }
    public var scheme: TileJSON.TileScheme? { tileJSON.scheme }
    public var template: String? { tileJSON.template }
    public var version: String? { tileJSON.version }
    
    // MARK: Decoding
    
    public init(from decoder: Decoder) throws {
        tileJSON = try .init(from: decoder)
        
        // Decode custom fields
        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let unusedEntries = try dynamicContainer.decode(filteringKeys: TileJSON.CodingKeys.allCases)
        customFields = unusedEntries.isEmpty ? nil : unusedEntries
    }
    
    // MARK: Encoding
    
    public func encode(to encoder: any Encoder) throws {
        try tileJSON.encode(to: encoder)
        
        if let customFields = customFields {
            var dynamicContainer = encoder.container(keyedBy: DynamicCodingKeys.self)
            for (key, value) in customFields {
                if let encodableValue = value as? Encodable {
                    try dynamicContainer.encode(encodableValue, forKey: DynamicCodingKeys(stringValue: key)!)
                }
            }
        }
    }
}
