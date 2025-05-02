//
//  OSMExampleTests.swift
//  SwiftTileJSON
//
//  Created by Scott Hoyt on 4/21/25.
//

import Foundation
import Testing
@testable import SwiftTileJSON
import Version

struct OSMExampleTests {
    @Test func osmExampleDecodes() {
        let tileJSON = try? JSONDecoder().decode(TileJSON.self, from: TestData.fromFile("osm")!)
        
        #expect(tileJSON != nil)
    }
    
    @Test func osmExampleExtendedFields() {
        let tileJSON = try! JSONDecoder().decode(ExtendedTileJSON.self, from: TestData.fromFile("osm")!)
        
        #expect(tileJSON.extendedFields["something_custom"] as? String == "this is my unique field")
    }
    
    @Test func osmExampleDecodesFieldsCorrectly() {
        let tileJSON = try! JSONDecoder().decode(TileJSON.self, from: TestData.fromFile("osm")!)
        
        #expect(tileJSON.tileJSONVersion == Version(3, 0, 0))
        #expect(tileJSON.name == "OpenStreetMap")
        #expect(tileJSON.description == "A free editable map of the whole world.")
        #expect(tileJSON.version == Version(1, 0, 0))
        #expect(tileJSON.attribution == "(c) OpenStreetMap contributors, CC-BY-SA")
        #expect(tileJSON.scheme == .xyz)
        #expect(tileJSON.tiles == [
            "https://a.tile.custom-osm-tiles.org/{z}/{x}/{y}.mvt",
            "https://b.tile.custom-osm-tiles.org/{z}/{x}/{y}.mvt",
            "https://c.tile.custom-osm-tiles.org/{z}/{x}/{y}.mvt"
        ])
        #expect(tileJSON.minZoom == 0)
        #expect(tileJSON.maxZoom == 18)
        #expect(tileJSON.bounds == TileJSON.Bounds(minLongitude: -180, minLatitude: -85, maxLongitude: 180, maxLatitude: 85))
        #expect(tileJSON.fillZoom == 6)
        #expect(tileJSON.vectorLayers == [
            TileJSON.VectorLayer(
                id: "telephone",
                fields: [
                    "phone_number" : "the phone number",
                    "payment": "how to pay"
                ]
            ),
            TileJSON.VectorLayer(
                id: "bicycle_parking",
                fields: [
                    "type" : "the type of bike parking",
                    "year_installed": "the year the bike parking was installed"
                ],
                maxZoom: 17
            ),
            TileJSON.VectorLayer(
                id: "showers",
                fields: [
                    "water_temperature" : "the maximum water temperature",
                    "wear_sandles": "whether you should wear sandles or not",
                    "wheelchair": "is the shower wheelchair friendly?"
                ],
                minZoom: 1
            )
        ])
        #expect(tileJSON.center == nil)
        #expect(tileJSON.data == nil)
        #expect(tileJSON.grids == nil)
        #expect(tileJSON.legend == nil)
        #expect(tileJSON.template == nil)
    }
}
