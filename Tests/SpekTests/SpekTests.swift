import XCTest
@testable import Spek

@available(iOS 15.0, *)
final class SpekTests: XCTestCase {
    func testExample() async {
        var left = 0
        var right = 0
        await spec {
            DescribeAsync("math") {
                BeforeEachAsync {
                    left = 2
                }

                DescribeAsync("basic") {
                    BeforeEachAsync {
                        right = 3
                    }

                    AfterEachAsync {

                    }

                    SubAsync {
                        let another = 4
                        return DescribeAsync("3 operands") {
                            ItAsync("adds with another") {
                                XCTAssertEqual(left + right + another, 9)
                            }
                        }
                    }

                    ItAsync("adds correctly") {
                        XCTAssertEqual(left + right, 5)
                    }

                    ItAsync("multiplies correctly") {
                        XCTAssertEqual(left * right, 6)
                    }
                }
            }
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
