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

The TileJSON 3.0 spec requires that all implementations provide access to custom key/value pairs that are included in the object, but not covered in the spec. The `TileJSON` object provides the `base` fields of the spec in a nested struct that preserves `Equatable` and `Hashable` conformance. Any additional fields are captured in the `extendedFields` property. `TileJSON.Base` can be used directly to encode/decode when `extendedFields` are not needed.

To improve the ergonomics of using `TileJSON`s and `TileJSON.Base`s together, both conform to the `TileJSONFields` protocol.

```swift
let tileJSON = try JSONDecoder().decode(TileJSON.self, from: tileJSONData)
let baseFields = tileJSON.base
let extendedFields = tileJSON.extendedFields

// You can utilize all base fields from either struct
print(tileJSON.name)
print(tileJSON.base.description)

// The underlying `TileJSON.Base` struct maintains `Equatable` and `Hashable` conformance.
let tileJSONBase = try JSONDecoder().decode(TileJSON.Base.self, from: tileJSONData)
assert(tileJSONBase == tileJSON.base)
```

## Default Values

The TileJSON 3.0 spec states that implementations MAY use default values for certain fields where they are not provided or invalid. In some use cases, it is useful to have access to the default values and to know when the original values were either not provided or invalid. To implement this, the `TileJSON` object contains `nil` values where fields were not provided or invalid, and the `TileJSONFields` protocol defines access to properties that are overriden with their default values in the case of a `nil` decoded value. These fields are named with the pattern `effectiveFieldName`.

```swift
let tileJSON = try JSONDecoder().decode(TileJSON.self, from: tileJSONData)
let maxZoomOrDefault = tileJSON.effectiveMaxZoom
```

