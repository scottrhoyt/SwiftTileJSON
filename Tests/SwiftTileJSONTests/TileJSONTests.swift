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
}
