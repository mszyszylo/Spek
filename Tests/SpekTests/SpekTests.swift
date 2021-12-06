import XCTest
@testable import Spek

@available(iOS 15.0, *)
final class SpekTests: XCTestCase {
    func testExample() async {
        var orderedInvocations = [Int]()
        let addNext = {
            guard let last = orderedInvocations.last else {
                orderedInvocations.append(.zero)
                return
            }
            orderedInvocations.append(last + 1)
        }
        await spec {
            var afterAllCalled = false
            var beforeAllCalled = false
            BeforeAllAsync {
                beforeAllCalled = true
                XCTAssertEqual(afterAllCalled, false)
                addNext()
            }
            AfterAllAsync {
                XCTAssertEqual(beforeAllCalled, true)
                afterAllCalled = true
                addNext()
            }
            DescribeAsync("") {
                var afterEachCalled = false
                var beforeEachCalled = false
                ItAsync("") {
                    XCTAssertEqual(beforeEachCalled, true)
                    XCTAssertEqual(afterEachCalled, false)
                    XCTAssertEqual(beforeAllCalled, true)
                    XCTAssertEqual(afterAllCalled, false)
                    addNext()
                }
                BeforeEachAsync {
                    beforeEachCalled = true
                    XCTAssertEqual(beforeAllCalled, true)
                    XCTAssertEqual(afterAllCalled, false)
                    addNext()
                }

                DescribeAsync("") {
                    let innerDescribeCalled = false
                    BeforeEachAsync {
                        addNext()
                        XCTAssertEqual(afterEachCalled, true)
                        XCTAssertEqual(beforeAllCalled, true)
                        XCTAssertEqual(afterAllCalled, false)
                        XCTAssertEqual(innerDescribeCalled, false)
                    }

                    AfterEachAsync {
                        addNext()
                        XCTAssertEqual(beforeAllCalled, true)
                        XCTAssertEqual(afterAllCalled, false)
                        XCTAssertEqual(innerDescribeCalled, false)
                    }

                    SubAsync {
                        DescribeAsync("") {
                            ItAsync("") {
                                addNext()
                                XCTAssertEqual(beforeAllCalled, true)
                                XCTAssertEqual(afterAllCalled, false)
                                XCTAssertEqual(orderedInvocations.count, 11)
                            }
                        }
                    }

                    ItAsync("") {
                        addNext()
                        XCTAssertEqual(beforeAllCalled, true)
                        XCTAssertEqual(afterAllCalled, false)
                        XCTAssertEqual(innerDescribeCalled, false)
                    }

                    ItAsync("") {
                        addNext()
                        XCTAssertEqual(beforeAllCalled, true)
                        XCTAssertEqual(afterAllCalled, false)
                        XCTAssertEqual(innerDescribeCalled, false)
                    }
                }
                AfterEachAsync {
                    addNext()
                    afterEachCalled = true
                    XCTAssertEqual(beforeAllCalled, true)
                    XCTAssertEqual(afterAllCalled, false)
                    XCTAssertEqual(orderedInvocations.count, 4)
                }
            }
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
