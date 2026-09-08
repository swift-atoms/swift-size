public import Magnitude
internal import Vector

extension Size where N == 1 {
    public init(length: Magnitude<Scalar>) {
        self.init(dimensions: Vector(x: length))
    }

    public init(length: Scalar) throws(Error) {
        self.init(length: try Magnitude(validating: length))
    }

    public var length: Magnitude<Scalar> { dimensions[0] }
}

extension Size where N == 2 {
    public init(width: Magnitude<Scalar>, height: Magnitude<Scalar>) {
        self.init(dimensions: Vector(x: width, y: height))
    }

    public init(width: Scalar, height: Scalar) throws(Error) {
        self.init(
            width: try Magnitude(validating: width),
            height: try Magnitude(validating: height)
        )
    }

    public var width: Magnitude<Scalar> { dimensions[0] }
    public var height: Magnitude<Scalar> { dimensions[1] }
}

extension Size where N == 3 {
    public init(width: Magnitude<Scalar>, height: Magnitude<Scalar>, depth: Magnitude<Scalar>) {
        self.init(dimensions: Vector(x: width, y: height, z: depth))
    }

    public init(width: Scalar, height: Scalar, depth: Scalar) throws(Error) {
        self.init(
            width: try Magnitude(validating: width),
            height: try Magnitude(validating: height),
            depth: try Magnitude(validating: depth)
        )
    }

    public var width: Magnitude<Scalar> { dimensions[0] }
    public var height: Magnitude<Scalar> { dimensions[1] }
    public var depth: Magnitude<Scalar> { dimensions[2] }
}
