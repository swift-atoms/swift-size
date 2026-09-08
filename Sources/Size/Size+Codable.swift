internal import Vector

#if !hasFeature(Embedded)
extension Size: Codable where Scalar: Codable {
    /// Vector checks the dimension count; Magnitude checks each dimension's value.
    public init(from decoder: any Decoder) throws {
        self.init(dimensions: try Vector(from: decoder))
    }

    public func encode(to encoder: any Encoder) throws {
        try dimensions.encode(to: encoder)
    }
}
#endif
