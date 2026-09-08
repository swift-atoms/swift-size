import Size
import Testing

@Suite
struct `Size dimensions` {
    @Test
    func `One dimensional sizes have a length`() throws {
        let size = try Size(length: 5)
        #expect(size.length.value == 5)
        #expect(size.values == Vector<1, Int>(x: 5))
    }

    @Test
    func `Two dimensional sizes use natural width and height labels`() throws {
        let size = try Size(width: 640, height: 480)
        #expect(size.width.value == 640)
        #expect(size.height.value == 480)
        #expect(size.values == Vector<2, Int>(x: 640, y: 480))
    }

    @Test
    func `Three dimensional sizes preserve all dimensions`() throws {
        let size = try Size(width: 2.0, height: 3.0, depth: 4.0)
        #expect(size.width.value == 2)
        #expect(size.height.value == 3)
        #expect(size.depth.value == 4)
    }

    @Test
    func `Validated magnitudes need no second validation`() throws {
        let width = try Magnitude(validating: 640)
        let height = try Magnitude(validating: 480)
        let size = Size(width: width, height: height)
        #expect(size.dimensions == Vector(x: width, y: height))
    }

    @Test
    func `Any negative dimension is rejected with the magnitude error`() {
        for values in [Vector<2, Int>(x: -1, y: 2), Vector<2, Int>(x: 1, y: -2)] {
            do {
                _ = try Size(validating: values)
                Issue.record("Expected negative dimension rejection")
            } catch {
                let failure: Magnitude<Int>.Error = error
                #expect(failure == .negative)
            }
        }
    }

    @Test
    func `Nonfinite dimensions are rejected`() {
        for invalid in [Double.nan, .infinity, -.infinity] {
            do {
                _ = try Size(width: 1.0, height: invalid, depth: 2.0)
                Issue.record("Expected nonfinite dimension rejection")
            } catch {
                #expect(error == .nonfinite)
            }
        }
    }

    @Test
    func `Negative zero is normalized by magnitude`() throws {
        let size = try Size(width: -0.0, height: 0.0)
        #expect(size == Size<2, Double>.zero)
        #expect(size.width.value.sign == .plus)
    }

    @Test
    func `Higher dimensional sizes use vector storage`() throws {
        let size = try Size(validating: Vector<4, Int>([1, 2, 3, 4]))
        #expect(size[3].value == 4)
        #expect(size.values == Vector<4, Int>([1, 2, 3, 4]))
    }

    @Test
    func `Zero dimensional sizes do not access a first component`() throws {
        let size = try Size(validating: Vector<0, Int>(repeating: -1))
        #expect(size == Size<0, Int>.zero)
        #expect(size.values == Vector<0, Int>(repeating: 0))
    }

    @Test
    func `Equality and hashing use the dimensions`() throws {
        let a = try Size(width: 2, height: 3)
        let b = try Size(width: 3, height: 2)
        #expect(a != b)
        #expect(Set([a, a, b]).count == 2)
    }

    @Test
    func `Sendability follows scalar storage`() {
        func requireSendable<T: Sendable>(_ value: T) {}
        requireSendable(Size<3, Double>.zero)
    }
}
