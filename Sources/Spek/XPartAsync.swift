//
//  XPart.swift
//  Spek
//
//  Created by khoa on 10/01/2020.
//

import Foundation

public struct XBeforeAllAsync: PartAsync {
    let closure: () throws -> Void

    public init(closure: @escaping () throws -> Void) {
        self.closure = closure
    }
}

public struct XAfterAllAsync: PartAsync {
    let closure: () throws -> Void

    public init(closure: @escaping () throws -> Void) {
        self.closure = closure
    }
}

public struct XBeforeEachAsync: PartAsync {
    let closure: () throws -> Void

    public init(closure: @escaping () throws -> Void) {
        self.closure = closure
    }
}

public struct XAfterEachAsync: PartAsync {
    let closure: () throws -> Void

    public init(closure: @escaping () throws -> Void) {
        self.closure = closure
    }
}

public struct XDescribeAsync: PartAsync {
    let name: String
    let parts: [PartAsync]

    public init(_ name: String, @PartBuilder builder: () -> [PartAsync]) {
        self.name = name
        self.parts = builder()
    }

    public init(_ name: String, @PartBuilder builder: () -> PartAsync) {
        self.name = name
        self.parts = [builder()]
    }
}

public struct XItAsync: PartAsync {
    let name: String
    let closure: () throws -> Void

    public init(_ name: String, closure: @escaping () throws -> Void) {
        self.name = name
        self.closure = closure
    }
}

public struct XSubAsync: PartAsync {
    let closure: () -> DescribeAsync
    public init(closure: @escaping () -> DescribeAsync) {
        self.closure = closure
    }
}

public typealias XContextAsync = XDescribeAsync
