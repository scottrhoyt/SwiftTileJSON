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
    @Test func extendedFieldsEncoding() {
        let extendedTileJSON = TileJSON(
            TileJSON.Base(
                tiles: ["http://a.tileserver.org/{z}/{x}/{y}"]
            ),
            extendedFields: [
                "something_custom": "this is my unique field",
                "another_custom": 42,
                "custom_dict": ["a": 1, "b": 2]
            ]
        )
        
        let jsonData = try! JSONEncoder().encode(extendedTileJSON)
        let decoded = try! JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
        
        #expect(decoded["something_custom"] as? String == "this is my unique field")
        #expect(decoded["another_custom"] as? Int == 42)
        #expect(decoded["custom_dict"] as? [String: Int] == ["a": 1, "b": 2])
    }
}
