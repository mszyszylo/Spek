//
//  XPart.swift
//  Spek
//
//  Created by khoa on 10/01/2020.
//

import Foundation

@available(iOS 15.0, *)
public struct XBeforeAllAsync: PartAsync {
    let closure: () async throws -> Void

    public init(closure: @escaping () async throws -> Void) {
        self.closure = closure
    }
}

@available(iOS 15.0, *)
public struct XAfterAllAsync: PartAsync {
    let closure: () async throws -> Void

    public init(closure: @escaping () async throws -> Void) {
        self.closure = closure
    }
}

@available(iOS 15.0, *)
public struct XBeforeEachAsync: PartAsync {
    let closure: () async throws -> Void

    public init(closure: @escaping () async throws -> Void) {
        self.closure = closure
    }
}

@available(iOS 15.0, *)
public struct XAfterEachAsync: PartAsync {
    let closure: () async throws -> Void

    public init(closure: @escaping () async throws -> Void) {
        self.closure = closure
    }
}

@available(iOS 15.0, *)
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

@available(iOS 15.0, *)
public struct XItAsync: PartAsync {
    let name: String
    let closure: () async throws -> Void

    public init(_ name: String, closure: @escaping () async throws -> Void) {
        self.name = name
        self.closure = closure
    }
}

@available(iOS 15.0, *)
public struct XSubAsync: PartAsync {
    let closure: () -> DescribeAsync
    public init(closure: @escaping () -> DescribeAsync) {
        self.closure = closure
    }
}

@available(iOS 15.0, *)
public typealias XContextAsync = XDescribeAsync
