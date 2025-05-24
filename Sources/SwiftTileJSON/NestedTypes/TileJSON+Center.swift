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
        /// The longitude in degrees (-180...180)
        public var longitude: Double
        
        /// The latitude in degrees (-90...90)
        public var latitude: Double
        
        /// The zoom level (0...30)
        public var zoom: Int
        
        /// Initialize a new ``Center`` object
        public init(longitude: Double, latitude: Double, zoom: Int) {
            self.longitude = longitude
            self.latitude = latitude
            self.zoom = zoom
        }
        
        /// Decode a ``Center`` object from a 3-element array.
        ///
        /// - Throws: A ``DecodingError`` when the array is not exactly 3 elements or they are out of
        ///   valid bounds.
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
        
        /// Encodes a ``Center`` object to a 3-element array.
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(longitude)
            try container.encode(latitude)
            try container.encode(zoom)
        }
    }
}
