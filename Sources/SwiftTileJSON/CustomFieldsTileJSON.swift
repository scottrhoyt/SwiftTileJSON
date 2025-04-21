//
//  CustomFieldsTileJSON.swift
//  SwiftTileJSON
//
//  Created by Scott Hoyt on 4/21/25.
//

import Foundation

/// A wrapper for handling arbitrary fields in a TileJSON object
public struct CustomFieldsTileJSON: Codable {
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
