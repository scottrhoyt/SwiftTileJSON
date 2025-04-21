//
//  ValidationTests.swift
//  SwiftTileJSON
//
//  Created by Scott Hoyt on 4/21/25.
//

import Foundation
import Testing
@testable import SwiftTileJSON

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
