//
//  Spek
//
//  Created by khoa on 00/01/2020.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

@resultBuilder
public struct PartBuilder {
    public static func buildBlock(_ parts: Part...) -> [Part] {
        parts
    }
}

public protocol Part {
    func run() async throws
}

public extension Part {
    func run() async throws {}
}

public struct BeforeAll: Part {
    let closure: () async throws -> Void

    public init(closure: @escaping () async throws -> Void) {
        self.closure = closure
    }

    public func run() async throws {
        try await closure()
    }
}

public struct AfterAll: Part {
    let closure: () async throws -> Void

    public init(closure: @escaping () async throws -> Void) {
        self.closure = closure
    }

    public func run() async throws {
        try await closure()
    }
}

public struct BeforeEach: Part {
    let closure: () async throws -> Void

    public init(closure: @escaping () async throws -> Void) {
        self.closure = closure
    }

    public func run() async throws {
        try await closure()
    }
}

public struct AfterEach: Part {
    let closure: () async throws -> Void

    public init(closure: @escaping () async throws -> Void) {
        self.closure = closure
    }

    public func run() async throws {
        try await closure()
    }
}

public struct Describe: Part {
    let name: String
    let parts: [Part]

    public init(_ name: String, parts: [Part] = []) {
        self.name = name
        self.parts = parts
    }

    public init(_ name: String, @PartBuilder builder: () -> [Part]) {
        self.init(name, parts: builder())
    }

    public init(_ name: String, @PartBuilder builder: () -> Part) {
        self.init(name, parts: [builder()])
    }

    public func run() async throws {
        for part in parts where part is BeforeAll {
            try await part.run()
        }

        for part in parts {
            for part in parts where part is BeforeEach {
                try await part.run()
            }

            switch part {
            case is It, is Describe, is Sub:
                try await part.run()
            default:
                break
            }

            for part in parts where part is AfterEach {
                try await part.run()
            }
        }
        for part in parts where part is AfterAll {
            try await part.run()
        }
    }
}

public struct It: Part {
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

public struct Sub: Part {
    let closure: () -> Describe
    public init(closure: @escaping () -> Describe) {
        self.closure = closure
    }

    public func run() async throws {
        try await closure().run()
    }
}

public typealias Context = Describe
