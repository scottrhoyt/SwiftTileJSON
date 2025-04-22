//
//  TileJSON+Center.swift
//  SwiftTileJSON
//
//  Created by Scott Hoyt on 4/21/25.
//

import Foundation

public extension TileJSON {
    /// Structured representation of TileJSON `center`
    struct Center: Equatable, Hashable, Codable, Sendable {
        public var longitude: Double
        public var latitude: Double
        public var zoom: Int
        
        public init(longitude: Double, latitude: Double, zoom: Int) {
            self.longitude = longitude
            self.latitude = latitude
            self.zoom = zoom
        }
        
        public init(from decoder: any Decoder) throws {
            var container = try decoder.unkeyedContainer()
            
            longitude = try container.decode(Double.self)
            latitude = try container.decode(Double.self)
            zoom = try container.decode(Int.self)
            
            if container.isAtEnd == false {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Expected 3 center values, but found more."
                    )
                )
            }
            
            if Valid.longitudeRange.contains(longitude) == false {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Invalid longitude value: \(longitude)"
                    )
                )
            }
            
            if Valid.latitudeRange.contains(latitude) == false {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Invalid latitude value: \(latitude)"
                    )
                )
            }
            
            if Valid.zoomRange.contains(zoom) == false {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Invalid zoom value: \(zoom)"
                    )
                )
            }
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(longitude)
            try container.encode(latitude)
            try container.encode(zoom)
        }
    }
}
