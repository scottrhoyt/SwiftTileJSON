//
//  KeyedDecodingContainer+SwiftTileJSON.swift
//  SwiftTileJSON
//
//  Created by Scott Hoyt on 4/21/25.
//

import Foundation

internal extension KeyedDecodingContainer {
    func decode(filteringKeys: [CodingKey] = []) throws -> [String: Sendable] {
        let fileringKeyStrings = filteringKeys.map(\.stringValue)
        var dictionary: [String: Sendable] = [:]
        
        for key in allKeys where !fileringKeyStrings.contains(key.stringValue) {
            if let value = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let container = try? nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: key) {
                dictionary[key.stringValue] = try container.decode()
            } else if var container = try? nestedUnkeyedContainer(forKey: key) {
                dictionary[key.stringValue] = try decodeArray(from: &container)
            } else {
                dictionary[key.stringValue] = nil
            }
        }
        
        return dictionary
    }
    
    private func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Sendable] {
        var array: [Sendable] = []
        
        while !container.isAtEnd {
            if let value = try? container.decode(String.self) {
                array.append(value)
            } else if let value = try? container.decode(Int.self) {
                array.append(value)
            } else if let value = try? container.decode(Double.self) {
                array.append(value)
            } else if let value = try? container.decode(Bool.self) {
                array.append(value)
            } else if let container = try? container.nestedContainer(keyedBy: DynamicCodingKeys.self) {
                array.append(try container.decode())
            } else if var container = try? container.nestedUnkeyedContainer() {
                array.append(try decodeArray(from: &container))
            } else {
                array.append(NSNull())
            }
        }
        
        return array
    }
}
