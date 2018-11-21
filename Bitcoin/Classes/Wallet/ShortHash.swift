//
//  ShortHash.swift
//  Bitcoin
//
//  Created by Wolf McNally on 11/15/18.
//
//  Copyright © 2018 Blockchain Commons.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import WolfPipe

public struct ShortHash {
    public let data: Data

    public init(_ data: Data) throws {
        guard data.count == 20 else {
            throw BitcoinError.invalidDataSize
        }
        self.data = data
    }
}

extension ShortHash: CustomStringConvertible {
    public var description: String {
        return data |> base16Encode
    }
}

extension ShortHash: Equatable {
    public static func == (lhs: ShortHash, rhs: ShortHash) -> Bool {
        return lhs.data == rhs.data
    }
}

// MARK: - Free functions

public func toShortHash(_ data: Data) throws -> ShortHash {
    return try ShortHash(data)
}
