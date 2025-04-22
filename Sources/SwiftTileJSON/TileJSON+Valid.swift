//
//  Valid.swift
//  SwiftTileJSON
//
//  Created by Scott Hoyt on 4/21/25.
//

import Foundation

extension TileJSON {
    /// Validation for TileJSON fields
    struct Valid {
        static let zoomRange: ClosedRange<Int> = 0...30
        static let latitudeRange: ClosedRange<Double> = -90...90
        static let longitudeRange: ClosedRange<Double> = -180...180
        
        /// Validates major version 3.
        static func tileJSONVersion(_ tileJSONVersion: String) -> Bool {
            let versionParts = tileJSONVersion.split(separator: ".")
            
            if versionParts.count < 1 {
                return false
            }
            
            if let majorVersion = Int(versionParts[0]), majorVersion == 3 {
                return true
            }
            
            return false
        }
        
        /// Validates that zoom levels are between 0...30 and maxZoom >= minzoom.
        static func zoomLevels(minZoom: Int?, maxZoom: Int?) -> (minZoom: Int?, maxZoom: Int?) {
            var validatedMinZoom: Int?
            var validatedMaxZoom: Int?
            
            if let minZoom = minZoom {
                validatedMinZoom = Valid.zoomRange.contains(minZoom) ? minZoom : nil
            }
            
            if let maxZoom = maxZoom {
                validatedMaxZoom = Valid.zoomRange.contains(maxZoom) ? maxZoom : nil
            }
            
            if let validatedMinZoom = validatedMinZoom, let validatedMaxZoom = validatedMaxZoom, validatedMinZoom > validatedMaxZoom {
                return (nil, nil)
            }
            
            return (validatedMinZoom, validatedMaxZoom)
        }
        
        /// Validates bounds
        static func bounds(_ bounds: [Double]?) -> [Double]? {
            guard
                let bounds = bounds,
                bounds.count == 4 &&
                    Valid.longitudeRange.contains(bounds[0]) &&
                    Valid.latitudeRange.contains(bounds[1]) &&
                    Valid.longitudeRange.contains(bounds[2]) &&
                    Valid.latitudeRange.contains(bounds[3])
            else {
                return nil
            }
            
            return bounds
        }
        
        /// Validates center
        static func center(_ center: [Double]?, minZoom: Int?, maxZoom: Int?, bounds: [Double]?) -> [Double]? {
            guard let center = center, center.count == 3 else { return nil }
            
            let centerLongitude = center[0]
            let centerLatitude = center[1]
            let centerZoom = Int(center[2])
            
            if
                Valid.longitudeRange.contains(centerLongitude) == false ||
                    Valid.latitudeRange.contains(centerLatitude) == false ||
                    Valid.zoomRange.contains(centerZoom) == false
            {
                return nil
            }
            
            if let minZoom = minZoom, let maxZoom = maxZoom, (minZoom...maxZoom).contains(centerZoom) == false {
                return nil
            }
            
            if let bounds = bounds, bounds.count == 4 {
                if
                    (bounds[0]...bounds[2]).contains(centerLongitude) == false ||
                        (bounds[1]...bounds[3]).contains(centerLatitude) == false
                {
                    return nil
                }
            }
            
            return center
        }
    }
}
