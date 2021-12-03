//
//  Spek
//
//  Created by khoa on 00/01/2020.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation
import XCTest

public func spec(@PartBuilder builder: () -> [PartAsync]) async {
    await run(parts: builder())
}

public func spec(@PartBuilder builder: () -> PartAsync) async {
    await run(parts: [builder()])
}

private func run(parts: [PartAsync]) async {
    do {
        for part in parts {
            try await part.run()
        }
    } catch {
        XCTFail(error.localizedDescription)
    }
}
