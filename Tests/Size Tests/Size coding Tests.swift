import Foundation
import Size
import Testing

@Suite
struct `Size coding preserves validated dimensions` {
    @Test
    func `Sizes reuse the vector representation and round trip`() throws {
        let size = try Size(width: 4, height: 3)
        let data = try JSONEncoder().encode(size)
        #expect(String(decoding: data, as: UTF8.self) == "[4,3]")
        #expect(try JSONDecoder().decode(Size<2, Int>.self, from: data) == size)
    }

    @Test(arguments: ["[-1,2]", "[1,-2]", "[]", "[1]", "[1,2,3]", "[1,null]"])
    func `Decoding cannot bypass dimension or magnitude validation`(_ json: String) {
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(Size<2, Int>.self, from: Data(json.utf8))
        }
    }

    @Test(arguments: ["NaN", "Infinity", "-Infinity"])
    func `Nonfinite scalar decoding still goes through magnitude validation`(_ value: String) {
        let decoder = JSONDecoder()
        decoder.nonConformingFloatDecodingStrategy = .convertFromString(
            positiveInfinity: "Infinity",
            negativeInfinity: "-Infinity",
            nan: "NaN"
        )
        #expect(throws: DecodingError.self) {
            try decoder.decode(Size<1, Double>.self, from: Data("[\"\(value)\"]".utf8))
        }
    }

    @Test
    func `Decoding normalizes negative zero`() throws {
        let size = try JSONDecoder().decode(Size<1, Double>.self, from: Data("[-0.0]".utf8))
        #expect(size.length.value.sign == .plus)
    }

    @Test
    func `Zero dimensional sizes encode and decode an empty array`() throws {
        let value = try JSONDecoder().decode(Size<0, Int>.self, from: Data("[]".utf8))
        #expect(value == .zero)
        #expect(try JSONEncoder().encode(value) == Data("[]".utf8))
    }
}

private func encode<let N: Int, Value: Magnitude::Scalar & Encodable>(
    _ value: Size<N, Value>
) throws -> Data {
    try JSONEncoder().encode(value)
}

private func decode<let N: Int, Value: Magnitude::Scalar & Decodable>(
    _ type: Size<N, Value>.Type,
    from data: Data
) throws -> Size<N, Value> {
    try JSONDecoder().decode(type, from: data)
}

@Test func `Size coding requires only the requested direction`() throws {
    let value = try Size(width: 4, height: 3)
    let data = try encode(value)
    #expect(try decode(Size<2, Int>.self, from: data) == value)
}
