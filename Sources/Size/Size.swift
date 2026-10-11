@_exported public import Magnitude
@_exported public import Vector

public struct Size<let N: Int, Scalar: Magnitude::Scalar> {
    public let dimensions: Vector<N, Magnitude<Scalar>>
    public typealias Error = Magnitude<Scalar>.Error

    public init(dimensions: Vector<N, Magnitude<Scalar>>) {
        self.dimensions = dimensions
    }

    public subscript(index: Int) -> Magnitude<Scalar> { dimensions[index] }
}

extension Size {

    public var values: Vector<N, Scalar> { Vector(self) }

    public static var zero: Self { Self(repeating: .zero) }
}

extension Size: Equatable {}
extension Size: Hashable where Scalar: Hashable {}
extension Size: Sendable where Scalar: Sendable {}

extension Size {
    public init(validating values: Vector<N, Scalar>) throws(Error) {
        let dimensions: InlineArray<N, Magnitude<Scalar>> = try InlineArray {
            (index: Int) throws(Error) in try Magnitude(validating: values[index])
        }
        self.init(dimensions: Vector(dimensions))
    }

    public init(repeating dimension: Magnitude<Scalar>) {
        self.init(dimensions: Vector(repeating: dimension))
    }
}

extension Vector where Scalar: Magnitude::Scalar {

    public init(_ size: Size<N, Scalar>) {
        self.init(size.dimensions.map(\.value).components)
    }
}
