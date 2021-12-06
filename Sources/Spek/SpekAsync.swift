//
//  Spek
//
//  Created by khoa on 00/01/2020.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation
import XCTest

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
    do {
        for part in parts where part is BeforeAllAsync {
            try await part.run()
        }
        for case let describe as DescribeAsync in parts {
            let describeParts = describe.parts
            for part in describeParts {
                switch part {
                case let it as ItAsync:
                    for part in describeParts where part is BeforeEachAsync {
                        try await part.run()
                    }
                    try await it.run()
                    for part in describeParts where part is AfterEachAsync {
                        try await part.run()
                    }
                default:
                    break
                }
            }
            for part in describeParts where part is DescribeAsync || part is SubAsync {
                switch part {
                case let nestedDescribe as DescribeAsync:
                    await run(parts: [nestedDescribe])
                case let sub as SubAsync:
                    await run(parts: [sub.closure()])
                default:
                    break
                }
            }
        }
        for part in parts where part is AfterAllAsync {
            try await part.run()
        }
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
