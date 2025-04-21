//
//  TestData.swift
//  SwiftTileJSON
//
//  Created by Scott Hoyt on 4/20/25.
//

import Foundation

struct TestData {
    static let dataDirectory = "Resources"
    
    static func fromFile(_ filename: String, withExtension: String = "json") -> Data? {
        guard let url = Bundle.module.url(forResource: filename, withExtension: withExtension, subdirectory: dataDirectory) else {
            return nil
        }
        
        return try? Data(contentsOf: url)
    }
}
