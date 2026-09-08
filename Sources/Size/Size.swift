@_exported public import Magnitude
@_exported public import Vector

/// Finite, nonnegative dimensions. A size has no position or orientation.
///
/// Magnitude owns scalar validation and Vector owns dimensional storage.
/// Signed changes belong to a displacement, not to Size's value domain.
public struct Size<let N: Int, Scalar: Magnitude::Scalar> {
    public let dimensions: Vector<N, Magnitude<Scalar>>
    public typealias Error = Magnitude<Scalar>.Error

    /// Construct from dimensions whose validity has already been established.
    public init(dimensions: Vector<N, Magnitude<Scalar>>) {
        self.dimensions = dimensions
    }

    public init(validating values: Vector<N, Scalar>) throws(Error) {
        let dimensions: InlineArray<N, Magnitude<Scalar>> = try InlineArray {
            (index: Int) throws(Error) in try Magnitude(validating: values[index])
        }
        self.init(dimensions: Vector(dimensions))
    }

    public init(repeating dimension: Magnitude<Scalar>) {
        self.init(dimensions: Vector(repeating: dimension))
    }

    public subscript(index: Int) -> Magnitude<Scalar> { dimensions[index] }

    public var values: Vector<N, Scalar> { dimensions.map(\.value) }

    public static var zero: Self { Self(repeating: .zero) }
}

extension Size: Equatable {}
extension Size: Hashable where Scalar: Hashable {}
extension Size: Sendable where Scalar: Sendable {}
