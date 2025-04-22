#  SwiftTileJSON

A Swift library for encoding/decoding [TileJSON 3.0](https://github.com/mapbox/tilejson-spec/tree/master/3.0.0).

## Custom Fields Handling

The TileJSON 3.0 spec requires that all implementations provide access to custom key/value pairs that are included in the object, but not covered in the spec. Adding the custom fields directly to the `TileJSON` struct (e.g. as a `[String: Any]`) would break useful `Equatable` and `Hashable` conformances. The solution in this library is to have `TileJSON` ignore custome fields, and to provide a `Codable` wrapper, `CustomFieldsTileJSON`, that can be used to when you want to work with custom fields. To use this functionality simply decode with the `CustomFieldsTileJSON` instead of `TileJSON` and you will have access to both the underlying `TileJSON` and the `customFields` values.

To improve the ergonomics of using `CustomFieldsTileJSON`s and `TileJSON`s together, both conform to the `TileJSONFields` protocol.

## Default Values

The TileJSON 3.0 spec states that implementations MAY use default values for certain fields where they are not provided or invalid. In some use cases, it is useful to have access to the default values and to know when the original values were either not provided or invalid. To implement this, the `TileJSON` object contains `nil` values where fields were not provided or invalid, and the `EffectiveTileJSONFields` protocol defines access to properties that are overriden with their default values in the case of a `nil` decoded value. These fields are named with the pattern `effectiveFieldName`.

