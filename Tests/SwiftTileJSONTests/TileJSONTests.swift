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
        let dataURL = Bundle.module.url(forResource: "osm", withExtension: "json", subdirectory: "Resources")
        let data = try! Data(contentsOf: dataURL!)
        let tileJSON = try? JSONDecoder().decode(TileJSON.self, from: data)
        
        #expect(tileJSON != nil)
    }
}
