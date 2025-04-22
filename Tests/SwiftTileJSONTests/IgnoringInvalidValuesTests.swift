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
    
    @Test(
        arguments: [
            [0.1],
            [0.1, 0.2],
            [0.1, 0.2, 0.3],
            [0.1, 0.2, 0.3, 0.4, 0.5]
        ]
    )
    func invalidTileJSONBoundsCountIgnored(bounds: [Double]) {
        let invalidTileJSONBounds: [String: Any] = [
            "tilejson": "3.0.0",
            "tiles": ["http://a.tileserver.org/{z}/{x}/{y}"],
            "bounds": bounds
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
    
    @Test(arguments: [-1, 31])
    func invalidTileJSONMaxZoomIgnored(maxZoom: Double) {
        let invalidTileJSONMaxZoom: [String: Any] = [
            "tilejson": "3.0.0",
            "tiles": ["http://a.tileserver.org/{z}/{x}/{y}"],
            "maxzoom": maxZoom
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: invalidTileJSONMaxZoom, options: [])
        let tileJSON = try! JSONDecoder().decode(TileJSON.self, from: jsonData)
        
        #expect(tileJSON.maxZoom == nil)
    }
    
    @Test(arguments: [-1, 31])
    func invalidTileJSONMinZoomIgnored(minZoom: Double) {
        let invalidTileJSONMinZoom: [String: Any] = [
            "tilejson": "3.0.0",
            "tiles": ["http://a.tileserver.org/{z}/{x}/{y}"],
            "minzoom": minZoom
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: invalidTileJSONMinZoom, options: [])
        let tileJSON = try! JSONDecoder().decode(TileJSON.self, from: jsonData)
        
        #expect(tileJSON.minZoom == nil)
    }
    
    @Test func invalidTileJSONMaxMinZoomIgnored() {
        let invalidTileJSONZoomLevels: [String: Any] = [
            "tilejson": "3.0.0",
            "tiles": ["http://a.tileserver.org/{z}/{x}/{y}"],
            "minzoom": 29,
            "maxzoom": 1
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: invalidTileJSONZoomLevels, options: [])
        let tileJSON = try! JSONDecoder().decode(TileJSON.self, from: jsonData)
        
        #expect(tileJSON.minZoom == nil)
        #expect(tileJSON.maxZoom == nil)
    }
    
    @Test(
        arguments: [
            [0.1],
            [0.1, 0.2],
            [0.1, 0.2, 0.3, 0.4]
        ]
    )
    func invalidTileJSONCenterCountIgnored(center: [Double]) {
        let invalidTileJSONCenter: [String: Any] = [
            "tilejson": "3.0.0",
            "tiles": ["http://a.tileserver.org/{z}/{x}/{y}"],
            "center": center
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: invalidTileJSONCenter, options: [])
        let tileJSON = try! JSONDecoder().decode(TileJSON.self, from: jsonData)
        
        #expect(tileJSON.center == nil)
    }
    
    @Test(
        arguments: [
            [-181, 0, 0],
            [181, 0, 0],
            [0, -91, 0],
            [0, 91, 0],
            [0, 0, -1],
            [0, 0, 31]
        ]
    )
    func invalidTileJSONCenterCoordinates(center: [Double]) {
        let invalidTileJSONCenter: [String: Any] = [
            "tilejson": "3.0.0",
            "tiles": ["http://a.tileserver.org/{z}/{x}/{y}"],
            "center": center
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: invalidTileJSONCenter, options: [])
        let tileJSON = try! JSONDecoder().decode(TileJSON.self, from: jsonData)
        
        #expect(tileJSON.center == nil)
    }
    
    @Test(
        arguments: [
            [-120, 0, 7],
            [120, 0, 7],
            [0, -80, 7],
            [0, 80, 7],
            [0, 0, 2],
            [0, 0, 12]
        ]
    )
    func invalidTileJSONCenterOutOfBounds(center: [Double]) {
        let invalidTileJSONCenter: [String: Any] = [
            "tilejson": "3.0.0",
            "tiles": ["http://a.tileserver.org/{z}/{x}/{y}"],
            "minzoom": 4,
            "maxzoom": 10,
            "bounds": [-100, -50, 100, 50],
            "center": center
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: invalidTileJSONCenter, options: [])
        let tileJSON = try! JSONDecoder().decode(TileJSON.self, from: jsonData)
        
        #expect(tileJSON.center == nil)
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
    
    @Test(
        arguments: [
            (nil, -1),
            (nil, 31),
            (-1, nil),
            (31, nil),
            (12, 4)
        ] as [(Int?, Int?)]
    )
    func invalidVectorLayersZoomLevelsIgnored(zoomLevels: (Int?, Int?)) {
        let invalidVectorLayer: [String: Any?] = [
            "id": "id",
            "fields": ["key": "value"],
            "minzoom": zoomLevels.0,
            "maxzoom": zoomLevels.1,
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: invalidVectorLayer, options: [])
        let vectorLayer = try! JSONDecoder().decode(TileJSON.VectorLayer.self, from: jsonData)
        
        #expect(vectorLayer.minZoom == nil)
        #expect(vectorLayer.maxZoom == nil)
    }
    
    @Test(
        arguments: [
            (1, nil),
            (nil, 17),
            (1, 17)
        ] as [(Int?, Int?)]
    )
    func invalidTileJSONVectorLayersZoomLevelsIgnored(zoomLevels: (Int?, Int?)) {
        let invalidTileJSONVectorLayer: [String: Any] = [
            "tilejson": "3.0.0",
            "tiles": ["http://a.tileserver.org"],
            "minzoom": 2,
            "maxzoom": 16,
            "vector_layers": [
                [
                    "id": "id",
                    "fields": ["key": "value"],
                    "minzoom": zoomLevels.0 as Any,
                    "maxzoom": zoomLevels.1 as Any,
                ]
            ]
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: invalidTileJSONVectorLayer, options: [])
        let tileJSON = try! JSONDecoder().decode(TileJSON.self, from: jsonData)
        
        #expect(tileJSON.vectorLayers![0].minZoom == nil)
        #expect(tileJSON.vectorLayers![0].maxZoom == nil)
    }
}
