//
//  TaskUtils.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 20/08/2022.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}
