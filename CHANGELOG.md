# 1.2.1

BUG FIXES:

* Remove a source of failure from inspecting a dynamic source.

# 1.2.0

This role now requires terraform 0.13 syntax.

BREAKING:

* If a certificate was not provisions now sets `output.arn` to `null` instead of an empty string.

# 1.1.0

FEATURES:

* Allow passing an empty map.

# 1.0.2

BUG FIXES:

* Fix multi-record validations not getting applied.

ENHANCEMENTS:

* Added an example for multi-zones.

# 1.0.1

BUG FIXES:

* Fix not possible to modify/delete a certificate already in use.

# 1.0

Initial release.
