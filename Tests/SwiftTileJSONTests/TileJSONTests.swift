//
//  TileJSONTests.swift
//  TileJSONTests
//
//  Created by Scott Hoyt on 4/20/25.
//

import Foundation
import Testing
@testable import SwiftTileJSON

struct OSMExampleTests {
    @Test func decodeOSMExample() {
        let dataURL = Bundle.main.url(forResource: "osm", withExtension: "json")
        let data = try! Data(contentsOf: dataURL!)
    }
}
