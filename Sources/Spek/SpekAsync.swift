//
//  Spek
//
//  Created by khoa on 00/01/2020.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation
import XCTest

/// ```
///  await spec {
///     BeforeAllAsync {...}
///     BeforeEachAsync {...}
///     DescribeAsync("") {
///         BeforeAllAsync {...}
///         BeforeEachAsync {...}
///         // All previous `BeforeAll(2)` called ONCE for incoming
///         // and nested `It's`!
///         ItAsync("") { /* All previous `BeforeEach(two)` called! */ }
///         ItAsync("") { /* All previous `BeforeEach(two)` called! */ }
///         ...
///         DescribeAsync("") {
///             BeforeEachAsync {...}
///             ItAsync("") { /* Only inner `BeforeEach(one)` called! */ }
///             ItAsync("") { /* Only inner `BeforeEach(one)` called! */ }
///         }
///     }
///  }
/// ```
/// - warning: Nested `DescribeAsync` doesn't know anything about
///            upper `Before` / `After` calls!
@available(iOS 15.0, *)
public func spec(@PartBuilder builder: () -> [PartAsync]) async {
    await run(parts: builder())
}

@available(iOS 15.0, *)
public func spec(@PartBuilder builder: () -> PartAsync) async {
    await run(parts: [builder()])
}

@available(iOS 15.0, *)
private func run(parts: [PartAsync]) async {
    /// Before each for parts
    let beforeEach = { (parts: [PartAsync]) in
        for part in parts where part is BeforeEachAsync {
            try await part.run()
        }
    }
    /// Before each for parts
    let beforeAll = { (parts: [PartAsync]) in
        for part in parts where part is BeforeAllAsync {
            try await part.run()
        }
    }
    /// After each for parts
    let afterEach = { (parts: [PartAsync]) in
        for part in parts where part is AfterEachAsync {
            try await part.run()
        }
    }
    /// After all for parts
    let afterAll = { (parts: [PartAsync]) in
        for part in parts where part is AfterAllAsync {
            try await part.run()
        }
    }

    /// Iterate
    do {
        /// Before all outer
        try await beforeAll(parts)
        /// Describe and beneath
        for case let describe as DescribeAsync in parts {
            /// Before all inner
            try await beforeAll(describe.parts)
            let describeParts = describe.parts
            for part in describeParts {
                switch part {
                case let it as ItAsync:
                    /// Also call the `BeforeEach` of upper trees
                    try await beforeEach(parts)
                    /// Call the `BeforeEach` of inner
                    try await beforeEach(describeParts)
                    try await it.run()
                    /// Also call the `AfterEach` of upper trees
                    try await afterEach(parts)
                    /// Call the `AfterEach` of inner
                    try await afterEach(describeParts)
                default:
                    break
                }
            }
            /// After all inner
            try await afterAll(describe.parts)
            /// Nested Describe retain
            for part in describeParts where part is DescribeAsync || part is SubAsync {
                switch part {
                case let nestedDescribe as DescribeAsync:
                    await run(parts: [nestedDescribe])
                case let sub as SubAsync:
                    let nestedDescribe = sub.closure()
                    await run(parts: [nestedDescribe])
                default:
                    break
                }
            }
        }
        /// After all outer
        try await afterAll(parts)
    } catch {
        XCTFail(error.localizedDescription)
    }
}

@available(iOS 15.0, *)
private extension DescribeAsync {
    func runBefore() async throws {
        for part in parts where part is BeforeAllAsync {
            try await part.run()
        }
        for part in parts where part is BeforeEachAsync {
            try await part.run()
        }
    }

    func runAfter() async throws {
        for part in parts where part is AfterEachAsync {
            try await part.run()
        }
        for part in parts where part is AfterAllAsync {
            try await part.run()
        }
    }
}
