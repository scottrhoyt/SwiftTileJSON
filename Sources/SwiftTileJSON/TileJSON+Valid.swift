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
        
        /// Validates center
        static func center(_ center: Center?, minZoom: Int?, maxZoom: Int?, bounds: Bounds?) -> Center? {
            guard let center = center else {
                return nil
            }
            
            if let minZoom = minZoom, let maxZoom = maxZoom, (minZoom...maxZoom).contains(center.zoom) == false {
                return nil
            }
            
            if
                let bounds = bounds,
                (bounds.minLongitude...bounds.maxLongitude).contains(center.longitude) == false ||
                (bounds.minLatitude...bounds.maxLatitude).self.contains(center.latitude) == false
            {
                return nil
            }
            
            return center
        }
        
        /// Validates VectorLayer zoom levels
        static func vectorLayer(_ vectorLayer: VectorLayer, minZoom: Int?, maxZoom: Int?) -> VectorLayer {
            var validatedVectorLayer = vectorLayer
            
            if let minZoom = minZoom, let vectorLayerMinZoom = vectorLayer.minZoom, vectorLayerMinZoom < minZoom {
                validatedVectorLayer.minZoom = nil
            }
            
            if let maxZoom = maxZoom, let vectorLayerMaxZoom = vectorLayer.maxZoom, vectorLayerMaxZoom > maxZoom {
                validatedVectorLayer.maxZoom = nil
            }
            
            return validatedVectorLayer
        }
    }
}
