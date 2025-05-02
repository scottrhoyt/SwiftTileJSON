//
//  TileJSON.swift
//  SwiftTileJSON
//
//  Created by Scott Hoyt on 4/21/25.
//

import Foundation
import Version

public typealias ExtendedField = Sendable & Encodable

/// A [TileJSON](https://github.com/mapbox/tilejson-spec/tree/master/3.0.0) object represents metadata about
/// multiple types of web-based map layers.
public struct TileJSON: Sendable {
    /// The base fields of the underlying TileJSON spec
    public let base: Base
    
    /// Additional fields not handled by the TileJSON spec
    public let extendedFields: [String: Sendable]
    
    /// Create a new `TileJSON` object
    /// - Parameters:
    ///   - base: The base TileJSON fields
    ///   - extendedFields: A dictionary of custom fields for encoding/decoding. Empty by default.
    public init(_ base: Base, extendedFields: [String: ExtendedField] = [:]) {
        self.base = base
        self.extendedFields = extendedFields
    }
}

// MARK: - TileJSONFields

extension TileJSON: TileJSONFields {
    public var tileJSON: Version { base.tileJSON }
    public var tiles: [String] { base.tiles }
    public var vectorLayers: [TileJSON.VectorLayer]? { base.vectorLayers }
    public var attribution: String? { base.attribution }
    public var bounds: TileJSON.Bounds? { base.bounds }
    public var center: TileJSON.Center? { base.center }
    public var data: [String]? { base.data }
    public var description: String? {base.description }
    public var fillZoom: Int? { base.fillZoom }
    public var grids: [String]? { base.grids }
    public var legend: String? { base.legend }
    public var maxZoom: Int? { base.maxZoom }
    public var minZoom: Int? { base.minZoom }
    public var name: String? { base.name }
    public var scheme: TileJSON.TileScheme? { base.scheme }
    public var template: String? { base.template }
    public var version: Version? { base.version }
}

// MARK: - Codable

extension TileJSON: Codable {
    public init(from decoder: Decoder) throws {
        base = try .init(from: decoder)
        
        // Decode custom fields
        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        extendedFields = try dynamicContainer.decode(filteringKeys: TileJSON.Base.CodingKeys.allCases)
    }
        
    public func encode(to encoder: any Encoder) throws {
        try base.encode(to: encoder)
        
        if extendedFields.isEmpty == false {
            var dynamicContainer = encoder.container(keyedBy: DynamicCodingKeys.self)
            for (key, value) in extendedFields {
                if let encodableValue = value as? Encodable {
                    try dynamicContainer.encode(encodableValue, forKey: DynamicCodingKeys(stringValue: key)!)
                }
            }
        }
    }
}
