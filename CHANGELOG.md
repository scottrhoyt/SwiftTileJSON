# Change Log

## `main`
* Constrain `extendedFields` initialization to be `Encodable`.
* Refactor `TileJSON` type to include extended fields and a `Base` object with the base fields. Remove `ExtendedTileJSON`.
* Rename `tileJSONVersion` to `tileJSON`.
* Reorganize.
* Clean up Documentation.
* Rename `TileJSON.Valid.tileJSONVersion` to `tileJSON`.

## 0.3.0
* Make `extendedFields` default to empty instead of `nil`.
* Use `Version` type to represent SemVers instead of Strings.
* Make types `Sendable`.

## 0.2.0
* Fix `TileJSON` init parameters
* Rename `CustomFieldsTileJSON` to `ExtendedTileJSON`
* Rename `ExtendedTileJSON.customFields` to `extendedFields`.
* Combine `EffectiveTileJSONFields` and `TileJSONFields`.

## 0.1.1
* Add more documentation

## 0.1.0
* Initial release
