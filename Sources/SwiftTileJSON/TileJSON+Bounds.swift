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
        /// The minimum longitude of the bounds
        public let minLongitude: Double
        
        /// The minimum latitude of the bounds
        public let minLatitude: Double
        
        /// The maximum longitude of the bounds
        public let maxLongitude: Double
        
        /// The maximum latitude of the bounds
        public let maxLatitude: Double
        
        public init(minLongitude: Double, minLatitude: Double, maxLongitude: Double, maxLatitude: Double) {
            self.minLongitude = minLongitude
            self.minLatitude = minLatitude
            self.maxLongitude = maxLongitude
            self.maxLatitude = maxLatitude
        }
        
        public init(from decoder: any Decoder) throws {
            var container = try decoder.unkeyedContainer()
            
            var decodedBounds = [Double]()
            while !container.isAtEnd {
                decodedBounds.append(try container.decode(Double.self))
            }
            
            if decodedBounds.count != 4 {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Expected 4 bounds values, but found \(decodedBounds.count)"
                    )
                )
            }
            
            minLongitude = decodedBounds[0]
            minLatitude = decodedBounds[1]
            maxLongitude = decodedBounds[2]
            maxLatitude = decodedBounds[3]
            
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
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(minLongitude)
            try container.encode(minLatitude)
            try container.encode(maxLongitude)
            try container.encode(maxLatitude)
        }
    }
}
