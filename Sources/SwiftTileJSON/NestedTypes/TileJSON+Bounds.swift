//
//  TileJSON+Bounds.swift
//  SwiftTileJSON
//
//  Created by Scott Hoyt on 4/21/25.
//

import Foundation

public extension TileJSON {
    /// Structured representation of TileJSON `bounds`
    /// - Note: According to the TileJSON spec, bounds cannot wrap the antimeridian.
    struct Bounds: Equatable, Hashable, Codable, Sendable {
        /// The minimum longitude (left side) of the bounds in degrees (-180...180)
        public let west: Double
        
        /// The minimum latitude (bottom side) of the bounds in degrees (-90...90)
        public let south: Double
        
        /// The minimum longitude (right side) of the bounds in degrees (-180...180)
        public let east: Double
        
        /// The maximum latitude (top side) of the bounds in degrees (-90...90)
        public let north: Double
        
        /// Initialize a new ``Bounds`` object
        public init(west: Double, south: Double, east: Double, north: Double) {
            self.west = west
            self.south = south
            self.east = east
            self.north = north
        }
        
        /// Decode a ``Bounds`` object from a 4-element array.
        ///
        /// - Throws: ``DecodingError`` if the array does not have exactly 4 elements or the elements are outside of valid ranges.
        public init(from decoder: any Decoder) throws {
            var container = try decoder.unkeyedContainer()
            
            west = try container.decode(Double.self)
            south = try container.decode(Double.self)
            east = try container.decode(Double.self)
            north = try container.decode(Double.self)
            
            if container.isAtEnd == false {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Expected 4 bounds values, but found more."
                    )
                )
            }
            
            if Valid.longitudeRange.contains(west) == false {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Invalid minLongitude value: \(west)"
                    )
                )
            }
            
            if Valid.latitudeRange.contains(south) == false {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Invalid minLatitude value: \(south)"
                    )
                )
            }
            
            if Valid.longitudeRange.contains(east) == false {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Invalid maxLongitude value: \(east)"
                    )
                )
            }
            
            if Valid.latitudeRange.contains(north) == false {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Invalid maxLatitude value: \(north)"
                    )
                )
            }
        }
        
        /// Encodes a `Bounds` object to a 4-element array
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(west)
            try container.encode(south)
            try container.encode(east)
            try container.encode(north)
        }
    }
}
