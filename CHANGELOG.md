# 2.0

This release of HTAutocompleteTextField contains _major breaking changes_ to clean up and simplify the library.

**[Breaking changes](#breaking-changes)**
1. Clarifying nomenclature and variable name changes from `autocomplete text` to `suggestion text`
1. Removal of `[HTAutocompleteTextField autocompleteButton]`
1. Supports iOS 7+
1. The data source is now responsible for whether or not to ignore character case (removed `[HTAutocompleteTextField ignoresCase]` property)
1. Removed support for setting a global autocomplete data source via `[HTAutocompleteTextField DefaultAutocompleteDataSource]`