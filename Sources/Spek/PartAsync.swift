//
//  Spek
//
//  Created by khoa on 00/01/2020.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

@available(iOS 15.0, *)
public protocol PartAsync {
    func run() async throws
}

@available(iOS 15.0, *)
public extension PartAsync {
    func run() async throws {}
}

@available(iOS 15.0, *)
public struct BeforeAllAsync: PartAsync {
    let closure: () async throws -> Void

    public init(closure: @escaping () async throws -> Void) {
        self.closure = closure
    }

    public func run() async throws {
        try await closure()
    }
}

@available(iOS 15.0, *)
public struct AfterAllAsync: PartAsync {
    let closure: () async throws -> Void

    public init(closure: @escaping () async throws -> Void) {
        self.closure = closure
    }

    public func run() async throws {
        try await closure()
    }
}

@available(iOS 15.0, *)
public struct BeforeEachAsync: PartAsync {
    let closure: () async throws -> Void

    public init(closure: @escaping () async throws -> Void) {
        self.closure = closure
    }

    public func run() async throws {
        try await closure()
    }
}

@available(iOS 15.0, *)
public struct AfterEachAsync: PartAsync {
    let closure: () async throws -> Void

    public init(closure: @escaping () async throws -> Void) {
        self.closure = closure
    }

    public func run() async throws {
        try await closure()
    }
}

@available(iOS 15.0, *)
public struct DescribeAsync: PartAsync {
    let name: String
    let parts: [PartAsync]

    public init(_ name: String, parts: [PartAsync] = []) {
        self.name = name
        self.parts = parts
    }

    public init(_ name: String, @PartBuilder builder: () -> [PartAsync]) {
        self.init(name, parts: builder())
    }

    public init(_ name: String, @PartBuilder builder: () -> PartAsync) {
        self.init(name, parts: [builder()])
    }

    public func run() async throws {
        for part in parts where part is BeforeAllAsync {
            try await part.run()
        }

        for part in parts {
            for part in parts where part is BeforeEachAsync {
                try await part.run()
            }

            switch part {
            case is ItAsync, is DescribeAsync, is SubAsync:
                try await part.run()
            default:
                break
            }

            for part in parts where part is AfterEachAsync {
                try await part.run()
            }
        }
        for part in parts where part is AfterAllAsync {
            try await part.run()
        }
    }
}

@available(iOS 15.0, *)
public struct ItAsync: PartAsync {
    let name: String
    let closure: () async throws -> Void

    public init(_ name: String, closure: @escaping () async throws -> Void) {
        self.name = name
        self.closure = closure
    }

    public func run() async throws {
        try await closure()
    }
}

@available(iOS 15.0, *)
public struct SubAsync: PartAsync {
    let closure: () -> DescribeAsync
    public init(closure: @escaping () -> DescribeAsync) {
        self.closure = closure
    }

    public func run() async throws {
        try await closure().run()
    }
}

@available(iOS 15.0, *)
public typealias ContextAsync = DescribeAsync
