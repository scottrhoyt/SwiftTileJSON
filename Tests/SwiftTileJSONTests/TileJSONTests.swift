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
        let tileJSON = try! TileJSON.decode(from: TestData.fromFile("osm")!)
        
        #expect(tileJSON.customFields?["something_custom"] as? String == "this is my unique field")
    }
}
