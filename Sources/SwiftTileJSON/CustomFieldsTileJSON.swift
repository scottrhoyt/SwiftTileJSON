//
//  CustomFieldsTileJSON.swift
//  SwiftTileJSON
//
//  Created by Scott Hoyt on 4/21/25.
//

import Foundation

/// A wrapper for handling custom fields in the TileJSON spec.
///
/// Custom fields are at the same level in the encoded/decoded TileJSON, but they stored under the
/// `customFields` property here to preserve a `TileJSON` object that conforms to `Equatable` and `Hashable`.
///
/// Access to the underlying `TileJSON` properties is available through the `TileJSONFields`
/// protocol.
public struct CustomFieldsTileJSON {
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
}

// MARK: - TileJSONFields

extension CustomFieldsTileJSON: TileJSONFields {
    public var tileJSONVersion: String { tileJSON.tileJSONVersion }
    public var tiles: [String] { tileJSON.tiles }
    public var vectorLayers: [TileJSON.VectorLayer]? { tileJSON.vectorLayers }
    public var attribution: String? { tileJSON.attribution }
    public var bounds: TileJSON.Bounds? { tileJSON.bounds }
    public var center: TileJSON.Center? { tileJSON.center }
    public var data: [String]? { tileJSON.data }
    public var description: String? {tileJSON.description }
    public var fillZoom: Int? { tileJSON.fillZoom }
    public var grids: [String]? { tileJSON.grids }
    public var legend: String? { tileJSON.legend }
    public var maxZoom: Int? { tileJSON.maxZoom }
    public var minZoom: Int? { tileJSON.minZoom }
    public var name: String? { tileJSON.name }
    public var scheme: TileJSON.TileScheme? { tileJSON.scheme }
    public var template: String? { tileJSON.template }
    public var version: String? { tileJSON.version }
}

// MARK: - Codable

extension CustomFieldsTileJSON: Codable {
    public init(from decoder: Decoder) throws {
        tileJSON = try .init(from: decoder)
        
        // Decode custom fields
        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let unusedEntries = try dynamicContainer.decode(filteringKeys: TileJSON.CodingKeys.allCases)
        customFields = unusedEntries.isEmpty ? nil : unusedEntries
    }
        
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
