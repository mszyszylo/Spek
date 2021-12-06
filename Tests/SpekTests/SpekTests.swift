import XCTest
@testable import Spek

@available(iOS 15.0, *)
final class SpekTests: XCTestCase {
    func testExample() async {
        await spec {
            var beforeAllCalled = 0
            var beforeEach1Called = 0
            var beforeEach2Called = 0
            var beforeEach3Called = 0
            BeforeAllAsync {
                beforeAllCalled += 1
            }
            BeforeEachAsync {
                beforeEach1Called += 1
            }
            DescribeAsync("") {
                BeforeAllAsync {
                    beforeAllCalled += 1
                }
                BeforeEachAsync {
                    beforeEach2Called += 1
                }
                ItAsync("") {
                    XCTAssertEqual(beforeAllCalled, 2)
                    XCTAssertEqual(beforeEach1Called, 1)
                    XCTAssertEqual(beforeEach2Called, 1)
                }
                ItAsync("") {
                    XCTAssertEqual(beforeAllCalled,2)
                    XCTAssertEqual(beforeEach1Called, 2)
                    XCTAssertEqual(beforeEach2Called, 2)
                }
                DescribeAsync("") {
                    BeforeEachAsync {
                        beforeEach3Called += 1
                    }
                    ItAsync("") {
                        XCTAssertEqual(beforeAllCalled, 2)
                        XCTAssertEqual(beforeEach1Called, 2)
                        XCTAssertEqual(beforeEach3Called, 1)
                    }
                    ItAsync("") {
                        XCTAssertEqual(beforeAllCalled, 2)
                        XCTAssertEqual(beforeEach1Called, 2)
                        XCTAssertEqual(beforeEach3Called, 2)
                    }
                }
            }
        }
        await spec {
            var innerAfterAllCalled = 0
            var outerAfterAllCalled = 0
            var afterEach1Called = 0
            var afterEach2Called = 0
            var afterEach3Called = 0
            AfterEachAsync {
                afterEach1Called += 1
            }
            AfterAllAsync {
                outerAfterAllCalled += 1
            }
            DescribeAsync("") {
                AfterAllAsync {
                    innerAfterAllCalled += 1
                }
                AfterEachAsync {
                    afterEach2Called += 1
                }
                ItAsync("") {
                    XCTAssertEqual(outerAfterAllCalled, 0)
                    XCTAssertEqual(innerAfterAllCalled, 0)
                    XCTAssertEqual(afterEach1Called, 0)
                    XCTAssertEqual(afterEach2Called, 0)
                }
                ItAsync("") {
                    XCTAssertEqual(outerAfterAllCalled, 0)
                    XCTAssertEqual(innerAfterAllCalled, 0)
                    XCTAssertEqual(afterEach1Called, 1)
                    XCTAssertEqual(afterEach2Called, 1)
                }
                DescribeAsync("") {
                    AfterEachAsync {
                        afterEach3Called += 1
                    }
                    ItAsync("") {
                        XCTAssertEqual(outerAfterAllCalled, 0)
                        XCTAssertEqual(innerAfterAllCalled, 1)
                        XCTAssertEqual(afterEach1Called, 2)
                        XCTAssertEqual(afterEach3Called, 0)
                    }
                    ItAsync("") {
                        XCTAssertEqual(outerAfterAllCalled, 0)
                        XCTAssertEqual(innerAfterAllCalled, 1)
                        XCTAssertEqual(afterEach1Called, 2)
                        XCTAssertEqual(afterEach3Called, 1)
                    }
                }
            }
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
