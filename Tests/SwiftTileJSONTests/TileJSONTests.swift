//
//  TileJSONTests.swift
//  SwiftTileJSONTests
//
//  Created by Scott Hoyt on 4/20/25.
//

import Foundation
import Testing
import SwiftTileJSON

struct OSMExampleTests {
    @Test func osmExampleDecodes() {
        let tileJSON = try? JSONDecoder().decode(TileJSON.self, from: TestData.fromFile("osm")!)
        
        #expect(tileJSON != nil)
    }
    
    @Test func osmExampleCustomFields() {
        let tileJSON = try! JSONDecoder().decode(CustomFieldsTileJSON.self, from: TestData.fromFile("osm")!)
        
        #expect(tileJSON.customFields?["something_custom"] as? String == "this is my unique field")
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
