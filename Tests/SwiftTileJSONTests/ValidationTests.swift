//
//  ValidationTests.swift
//  SwiftTileJSON
//
//  Created by Scott Hoyt on 4/21/25.
//

import Foundation
import Testing
@testable import SwiftTileJSON
import Version

struct ValidationTests {
    @Test func noTilesJSONThrows() {
        let invalidTileJSON: [String: Any] = [
            "tiles": ["https://a.tileserver.org"]
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: invalidTileJSON, options: [])
        
        #expect(performing: {
            _ = try JSONDecoder().decode(TileJSON.self, from: jsonData)
        }, throws: { error in
            guard let error = error as? DecodingError else { return false }
            switch error {
            case .keyNotFound(let codingKey, _):
                return codingKey.stringValue == TileJSON.CodingKeys.tileJSONVersion.stringValue
            default:
                return false
            }
        })
    }
    
    @Test func noTilesThrows() {
        let invalidTileJSON: [String: Any] = [
            "tilejson": "3.0.0"
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: invalidTileJSON, options: [])
        
        #expect(performing: {
            _ = try JSONDecoder().decode(TileJSON.self, from: jsonData)
        }, throws: { error in
            guard let error = error as? DecodingError else { return false }
            switch error {
            case .keyNotFound(let codingKey, _):
                return codingKey.stringValue == TileJSON.CodingKeys.tiles.stringValue
            default:
                return false
            }
        })
    }
    
    @Test func emptyTilesThrows() {
        let invalidTileJSON: [String: Any] = [
            "tilejson": "3.0.0",
            "tiles": []
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: invalidTileJSON, options: [])
        
        #expect(performing: {
            _ = try JSONDecoder().decode(TileJSON.self, from: jsonData)
        }, throws: { error in
            guard let error = error as? DecodingError else { return false }
            switch error {
            case .dataCorrupted(let context):
                return context.debugDescription == "TileJSON requires at least one tile endpoint."
            default:
                return false
            }
        })
    }
    
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
            "3.0.0-a",
            "3.0.0-experimental"
        ]
    )
    func validatesVersion(versionString: String) {
        let validTileJSON: [String: Any] = [
            "tilejson": versionString,
            "tiles": ["http://a.tileserver.org/{z}/{x}/{y}"]
        ]

        let jsonData = try! JSONSerialization.data(withJSONObject: validTileJSON)
        let decoder = JSONDecoder()
        decoder.userInfo[.decodingMethod] = DecodingMethod.tolerant
        let tileJSON = try! decoder.decode(TileJSON.self, from: jsonData)
        
        #expect(tileJSON.tileJSONVersion == Version(tolerant: versionString)!)
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
    func invalidVersionThrows(versionString: String) {
        let invalidTileJSON: [String: Any] = [
            "tilejson": versionString,
            "tiles": ["http://a.tileserver.org/{z}/{x}/{y}"]
        ]

        let jsonData = try! JSONSerialization.data(withJSONObject: invalidTileJSON)
        #expect(performing: {
            let decoder = JSONDecoder()
            decoder.userInfo[.decodingMethod] = DecodingMethod.tolerant
            _ = try decoder.decode(TileJSON.self, from: jsonData)
        }, throws: { error in
            switch error as? DecodingError {
            case .typeMismatch(_, let context):
                return context.debugDescription == "Only TileJSON v3.x.x is supported"
            case .dataCorrupted(let context):
                return context.debugDescription == "Invalid semantic version"
            default:
                return false
            }
        })
    }
    
    @Test func validCenterDecodes() {
        let validTileJSON: [String: Any] = [
            "tilejson": "3.0.0",
            "tiles": ["http://a.tileserver.org/{z}/{x}/{y}"],
            "minzoom": 4,
            "maxzoom": 12,
            "bounds": [-100, -50, 100, 50],
            "center": [-20, 20, 7]
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: validTileJSON)
        let tileJSON = try! JSONDecoder().decode(TileJSON.self, from: jsonData)
        
        #expect(tileJSON.center == TileJSON.Center(longitude: -20, latitude: 20, zoom: 7))
    }
}
