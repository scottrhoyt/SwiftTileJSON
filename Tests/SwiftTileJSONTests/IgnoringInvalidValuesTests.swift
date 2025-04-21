//
//  IgnoringInvalidValuesTests.swift
//  SwiftTileJSON
//
//  Created by Scott Hoyt on 4/21/25.
//

import Foundation
import Testing
@testable import SwiftTileJSON

struct IgnoringInvalidValuesTests {
    @Test func invalidTileJSONOptionalValuesIgnored() {
        let invalidTileJSON: [String: Any] = [
            "tilejson": "3.0.0",
            "tiles": ["http://a.tileserver.org/{z}/{x}/{y}"],
            "vector_layers": "invalid",
            "attribution": -1,
            "bounds": "invalid",
            "center": "invalid",
            "data": "invalid",
            "description": -1,
            "fillzoom": "invalid",
            "grids": "invalid",
            "legend": -1,
            "maxzoom": "invalid",
            "minzoom": "invalid",
            "name": -1,
            "scheme": "invalid",
            "template": -1,
            "version": -1
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: invalidTileJSON, options: [])
        let tileJSON = try! JSONDecoder().decode(TileJSON.self, from: jsonData)
        
        #expect(tileJSON.vectorLayers == nil)
        #expect(tileJSON.attribution == nil)
        #expect(tileJSON.bounds == nil)
        #expect(tileJSON.center == nil)
        #expect(tileJSON.data == nil)
        #expect(tileJSON.description == nil)
        #expect(tileJSON.fillZoom == nil)
        #expect(tileJSON.grids == nil)
        #expect(tileJSON.legend == nil)
        #expect(tileJSON.maxZoom == nil)
        #expect(tileJSON.minZoom == nil)
        #expect(tileJSON.name == nil)
        #expect(tileJSON.scheme == nil)
        #expect(tileJSON.template == nil)
        #expect(tileJSON.version == nil)
    }
    
    @Test func invalidTileJSONBoundsCountIgnored() {
        let invalidTileJSONBounds: [String: Any] = [
            "tilejson": "3.0.0",
            "tiles": ["http://a.tileserver.org/{z}/{x}/{y}"],
            "bounds": [1.1, 1.2, 1.3]
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: invalidTileJSONBounds, options: [])
        let tileJSON = try! JSONDecoder().decode(TileJSON.self, from: jsonData)
        
        #expect(tileJSON.bounds == nil)
    }
    
    @Test(
        arguments: [
            [-181, 0, 0, 0],
            [0, -91, 0, 0],
            [0, 0, 181, 0],
            [0, 0, 0, 91]
        ]
    )
    func invalidTileJSONBoundsRangeIgnored(bounds: [Double]) {
        let invalidTileJSONBounds: [String: Any] = [
            "tilejson": "3.0.0",
            "tiles": ["http://a.tileserver.org/{z}/{x}/{y}"],
            "bounds": bounds
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: invalidTileJSONBounds, options: [])
        let tileJSON = try! JSONDecoder().decode(TileJSON.self, from: jsonData)
        
        #expect(tileJSON.bounds == nil)
    }
    
    @Test func invalidVectorLayersOptionalValuesIgnored() {
        let invalidVectorLayer: [String: Any] = [
            "id": "id",
            "fields": ["key": "value"],
            "description": -1,
            "maxzoom": "invalid",
            "minzoom": "invalid",
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: invalidVectorLayer, options: [])
        let vectorLayer = try! JSONDecoder().decode(TileJSON.VectorLayer.self, from: jsonData)
        
        #expect(vectorLayer.description == nil)
        #expect(vectorLayer.minZoom == nil)
        #expect(vectorLayer.maxZoom == nil)
    }
}
