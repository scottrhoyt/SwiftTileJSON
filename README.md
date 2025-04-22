#  SwiftTileJSON

A Swift library for encoding/decoding [TileJSON 3.0](https://github.com/mapbox/tilejson-spec/tree/master/3.0.0).

## Usage

```swift
let tileJSON = try JSONDecoder().decode(TileJSON.self, from: tileJSONData)
```

## Structured `Bounds` and `Center`

The TileJSON 3.0 spec uses arrays with implicit structure for the `bounds` and `center` fields. To make working with this data eaiser, SwiftTileJSON maps these to the `TileJSON.Bounds` and `TileJSON.Center` structs.

```swift
let tileJSON = try JSONDecoder().decode(TileJSON.self, from: tileJSONData)
print(tileJSON.bounds?.maxLongitude)
print(tileJSON.center?.zoom)
```

## Custom Fields Handling

The TileJSON 3.0 spec requires that all implementations provide access to custom key/value pairs that are included in the object, but not covered in the spec. Adding the custom fields directly to the `TileJSON` struct (e.g. as a `[String: Any]`) would break useful `Equatable` and `Hashable` conformances. The solution in this library is to have `TileJSON` ignore custom fields, and to provide a `Codable` wrapper, `CustomFieldsTileJSON`, that can be used to when you want to work with custom fields. To use this functionality simply decode with the `CustomFieldsTileJSON` instead of `TileJSON` and you will have access to both the underlying `TileJSON` and the `customFields` values.

To improve the ergonomics of using `CustomFieldsTileJSON`s and `TileJSON`s together, both conform to the `TileJSONFields` protocol.

```swift
let tileJSONWithCustomFields = try JSONDecoder().decode(CustomFieldsTileJSON.self, from: tileJSONData)
let underlyingTileJSON = tileJSONWithCustomFields.tileJSON
let customFields = tileJSONWithCustomFields.customFields

// You can still utilize the underlying fields
print(tileJSONWithCustomFields.name)
print(tileJSONWithCustomFields.description)
```

## Default Values

The TileJSON 3.0 spec states that implementations MAY use default values for certain fields where they are not provided or invalid. In some use cases, it is useful to have access to the default values and to know when the original values were either not provided or invalid. To implement this, the `TileJSON` object contains `nil` values where fields were not provided or invalid, and the `EffectiveTileJSONFields` protocol defines access to properties that are overriden with their default values in the case of a `nil` decoded value. These fields are named with the pattern `effectiveFieldName`.

```swift
let tileJSON = try JSONDecoder().decode(TileJSON.self, from: tileJSONData)
let maxZoomOrDefault = tileJSON.effectiveMaxZoom
```

