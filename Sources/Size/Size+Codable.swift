internal import Vector

#if !hasFeature(Embedded)
    extension Size: Decodable where Scalar: Decodable {

        public init(from decoder: any Decoder) throws {
            self.init(dimensions: try Vector(from: decoder))
        }

    }

    extension Size: Encodable where Scalar: Encodable {
        public func encode(to encoder: any Encoder) throws {
            try dimensions.encode(to: encoder)
        }
    }
#endif
