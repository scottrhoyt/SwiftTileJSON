//
//  EncodingTests.swift
//  SwiftTileJSON
//
//  Created by Scott Hoyt on 4/21/25.
//

import Foundation
import Testing
@testable import SwiftTileJSON

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
