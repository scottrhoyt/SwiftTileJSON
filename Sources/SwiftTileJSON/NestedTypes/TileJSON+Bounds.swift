//
//  TileJSON+Bounds.swift
//  SwiftTileJSON
//
//  Created by Scott Hoyt on 4/21/25.
//

import Foundation

public extension TileJSON {
    /// Structured representation of TileJSON `bounds`
    struct Bounds: Equatable, Hashable, Codable, Sendable {
        /// The minimum longitude (left side) of the bounds in degrees (-180...180)
        public let minLongitude: Double
        
        /// The minimum latitude (bottom side) of the bounds in degrees (-90...90)
        public let minLatitude: Double
        
        /// The minimum longitude (right side) of the bounds in degrees (-180...180)
        public let maxLongitude: Double
        
        /// The maximum latitude (top side) of the bounds in degrees (-90...90)
        public let maxLatitude: Double
        
        /// Initialize a new ``Bounds`` object
        public init(minLongitude: Double, minLatitude: Double, maxLongitude: Double, maxLatitude: Double) {
            self.minLongitude = minLongitude
            self.minLatitude = minLatitude
            self.maxLongitude = maxLongitude
            self.maxLatitude = maxLatitude
        }
        
        /// Decode a ``Bounds`` object from a 4-element array.
        ///
        /// - Throws: ``DecodingError`` if the array does not have exactly 4 elements or the elements are outside of valid ranges.
        public init(from decoder: any Decoder) throws {
            var container = try decoder.unkeyedContainer()
            
            minLongitude = try container.decode(Double.self)
            minLatitude = try container.decode(Double.self)
            maxLongitude = try container.decode(Double.self)
            maxLatitude = try container.decode(Double.self)
            
            if container.isAtEnd == false {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Expected 4 bounds values, but found more."
                    )
                )
            }
            
            if Valid.longitudeRange.contains(minLongitude) == false {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Invalid minLongitude value: \(minLongitude)"
                    )
                )
            }
            
            if Valid.latitudeRange.contains(minLatitude) == false {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Invalid minLatitude value: \(minLatitude)"
                    )
                )
            }
            
            if Valid.longitudeRange.contains(maxLongitude) == false {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Invalid maxLongitude value: \(maxLongitude)"
                    )
                )
            }
            
            if Valid.latitudeRange.contains(maxLatitude) == false {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Invalid maxLatitude value: \(maxLatitude)"
                    )
                )
            }
        }
        
        /// Encodes a `Bounds` object to a 4-element array
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(minLongitude)
            try container.encode(minLatitude)
            try container.encode(maxLongitude)
            try container.encode(maxLatitude)
        }
    }
}
