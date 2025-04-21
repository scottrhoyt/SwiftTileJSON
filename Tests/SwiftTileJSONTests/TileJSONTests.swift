//
//  TileJSONTests.swift
//  SwiftTileJSONTests
//
//  Created by Scott Hoyt on 4/20/25.
//

import Foundation
import Testing
@testable import SwiftTileJSON

struct OSMExampleTests {
    @Test func osmExampleDecodes() {
        let tileJSON = try? JSONDecoder().decode(TileJSON.self, from: TestData.fromFile("osm")!)
        
        #expect(tileJSON != nil)
    }
    
    @Test func osmExampleCustomFields() {
        let tileJSON = try! JSONDecoder().decode(CustomFieldsTileJSON.self, from: TestData.fromFile("osm")!)
        
        #expect(tileJSON.customFields?["something_custom"] as? String == "this is my unique field")
    }
    
    @Test func osmExampleDecodesFieldsCorrectly() {
        let tileJSON = try! JSONDecoder().decode(TileJSON.self, from: TestData.fromFile("osm")!)
        
        #expect(tileJSON.tileJSONVersion == "3.0.0")
        #expect(tileJSON.name == "OpenStreetMap")
        #expect(tileJSON.description == "A free editable map of the whole world.")
        #expect(tileJSON.version == "1.0.0")
        #expect(tileJSON.attribution == "(c) OpenStreetMap contributors, CC-BY-SA")
        #expect(tileJSON.scheme == .xyz)
        #expect(tileJSON.tiles == [
            "https://a.tile.custom-osm-tiles.org/{z}/{x}/{y}.mvt",
            "https://b.tile.custom-osm-tiles.org/{z}/{x}/{y}.mvt",
            "https://c.tile.custom-osm-tiles.org/{z}/{x}/{y}.mvt"
        ])
        #expect(tileJSON.minZoom == 0)
        #expect(tileJSON.maxZoom == 18)
        #expect(tileJSON.bounds == [-180, -85, 180, 85])
        #expect(tileJSON.fillzoom == 6)
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
                maxZoom: 29
            ),
            TileJSON.VectorLayer(
                id: "showers",
                fields: [
                    "water_temperature" : "the maximum water temperature",
                    "wear_sandles": "whether you should wear sandles or not",
                    "wheelchair": "is the shower wheelchair friendly?"
                ],
                minZoom: 12
            )
        ])
        #expect(tileJSON.center == nil)
        #expect(tileJSON.data == nil)
        #expect(tileJSON.grids == nil)
        #expect(tileJSON.legend == nil)
        #expect(tileJSON.template == nil)
    }
}

struct EncodingTests {
    @Test func customFieldsEncoding() {
        let tileJSON = TileJSON(tilejson: "3.0.0", tiles: ["http://a.tileserver.org/{z}/{x}/{y}"])
        let customFields: [String: Any] = [
            "something_custom": "this is my unique field",
            "another_custom": 42
        ]
        let customFieldsTileJSON = CustomFieldsTileJSON(tileJSON: tileJSON, customFields: customFields)
        
        let jsonData = try! JSONEncoder().encode(customFieldsTileJSON)
        let decoded = try! JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
        
        #expect(decoded["something_custom"] as? String == "this is my unique field")
        #expect(decoded["another_custom"] as? Int == 42)
    }
}

struct ValidationTests {
    @Test(
        arguments: [
            "3.0.0",
            "3.0.1",
            "3.1.0",
            "03.0.0",
            "3",
            "03",
            "3.0",
            "03.0",
            "3.0.0.",
            "3.0.0a",
            "3.0.0-experimental"
        ]
    )
    func validatesVersion(versionString: String) {
        let validTileJSON: [String: Any] = [
            "tilejson": versionString,
            "tiles": ["http://a.tileserver.org/{z}/{x}/{y}"]
        ]

        let jsonData = try! JSONSerialization.data(withJSONObject: validTileJSON)
        let tileJSON = try! JSONDecoder().decode(TileJSON.self, from: jsonData)
        
        #expect(tileJSON.tileJSONVersion == versionString)
    }
    
    @Test(
        arguments: [
            "",
            "1.0.0",
            "2.0.1",
            "4.1.0",
            "1.0",
            "2",
            "0",
            "version3"
        ]
    )
    func invalidatesVersion(versionString: String) {
        let invalidTileJSON: [String: Any] = [
            "tilejson": versionString,
            "tiles": ["http://a.tileserver.org/{z}/{x}/{y}"]
        ]

        let jsonData = try! JSONSerialization.data(withJSONObject: invalidTileJSON)
        #expect(performing: {
            _ = try JSONDecoder().decode(TileJSON.self, from: jsonData)
        }, throws: { error in
            switch error as? DecodingError {
            case .typeMismatch(_, let context):
                return context.debugDescription == "Only TileJSON v3.x.x is supported"
            default:
                return false
            }
        })
    }
}
