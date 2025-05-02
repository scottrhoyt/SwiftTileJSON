//
//  EffectiveValuesTests.swift
//  SwiftTileJSON
//
//  Created by Scott Hoyt on 4/21/25.
//

import Foundation
import Testing
@testable import SwiftTileJSON

struct EffectiveValuesTests {
    @Test func tileJSONeffectiveValues() {
        let validTileJSON: [String: Any] = [
            "tilejson": "3.0.0",
            "tiles": ["http://a.tileserver.org/{z}/{x}/{y}"]
        ]

        let jsonData = try! JSONSerialization.data(withJSONObject: validTileJSON)
        let tileJSON = try! JSONDecoder().decode(TileJSON.self, from: jsonData)
        
        #expect(tileJSON.effectiveBounds == TileJSON.Defaults.bounds)
        #expect(tileJSON.effectiveMaxZoom == TileJSON.Defaults.maxZoom)
        #expect(tileJSON.effectiveMinZoom == TileJSON.Defaults.minZoom)
        #expect(tileJSON.effectiveScheme == TileJSON.Defaults.scheme)
        #expect(tileJSON.effectiveVersion == TileJSON.Defaults.version)
        #expect(tileJSON.effectiveData == TileJSON.Defaults.data)
        #expect(tileJSON.effectiveGrids == TileJSON.Defaults.grids)
    }
    
    @Test func customFieldsTileJSONeffectiveValues() {
        let validTileJSON: [String: Any] = [
            "tilejson": "3.0.0",
            "tiles": ["http://a.tileserver.org/{z}/{x}/{y}"]
        ]

        let jsonData = try! JSONSerialization.data(withJSONObject: validTileJSON)
        let tileJSON = try! JSONDecoder().decode(ExtendedTileJSON.self, from: jsonData)
        
        #expect(tileJSON.effectiveBounds == TileJSON.Defaults.bounds)
        #expect(tileJSON.effectiveMaxZoom == TileJSON.Defaults.maxZoom)
        #expect(tileJSON.effectiveMinZoom == TileJSON.Defaults.minZoom)
        #expect(tileJSON.effectiveScheme == TileJSON.Defaults.scheme)
        #expect(tileJSON.effectiveVersion == TileJSON.Defaults.version)
        #expect(tileJSON.effectiveData == TileJSON.Defaults.data)
        #expect(tileJSON.effectiveGrids == TileJSON.Defaults.grids)
    }
}
