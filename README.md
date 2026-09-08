# Size

Finite, nonnegative dimensions, represented by Vector of Magnitude.

```swift
import Size

let rectangle = try Size(width: 640, height: 480)
let box = try Size(width: 2.0, height: 3.0, depth: 4.0)

let width = try Magnitude(validating: 640)
let height = try Magnitude(validating: 480)
let validated = Size(width: width, height: height) // no repeated validation
```

Magnitude and Vector are reexported because they appear in the public model.
Magnitude owns nonnegative/finite validation, including negative-zero normalization.
Size reuses its error type rather than inventing a second validation taxonomy.

A size has no origin, direction, frame, units, ordering, or additive-group conformance.
Those interpretations are not implied by dimensional storage. Signed changes are
displacements. Frame identity can be provided separately by tagging a size.

Zero extents are valid. N = 0 is supported as an empty dimension vector.

When the scalar is Codable, sizes encode as an array in dimension order.
Decoding delegates to Vector for exact dimension-count validation and to Magnitude
for finite, nonnegative values. Empty dimensions decode from `[]`; extra components,
negative values, and nonfinite values are rejected rather than silently repaired.
