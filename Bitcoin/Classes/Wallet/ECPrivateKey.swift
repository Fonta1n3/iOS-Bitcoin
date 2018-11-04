//
//  ECPrivateKey.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/30/18.
//

import CBitcoin
import WolfPipe

public let ecPrivateKeySize: Int = { return _ecPrivateKeySize() }()

public struct ECPrivateKey {
    public let data: Data

    public init(_ data: Data) throws {
        guard data.count == ecPrivateKeySize else {
            throw BitcoinError.invalidDataSize
        }
        self.data = data
    }
}

public func toECPrivateKey(_ data: Data) throws -> ECPrivateKey {
    return try ECPrivateKey(data)
}

public func base16Encode(_ privateKey: ECPrivateKey) -> String {
    return privateKey.data |> base16Encode
}

/// Create a new EC private key from entropy.
public func newECPrivateKey(_ seed: Data) throws -> ECPrivateKey {
    guard seed.count >= minimumSeedSize else {
        throw BitcoinError.seedTooSmall
    }
    var privateKeyBytes: UnsafeMutablePointer<UInt8>!
    var privateKeyLength: Int = 0
    try seed.withUnsafeBytes { (seedBytes: UnsafePointer<UInt8>) in
        if let error = BitcoinError(rawValue: _ecNewPrivateKey(seedBytes, seed.count, &privateKeyBytes, &privateKeyLength)) {
            throw error
        }
    }
    return try ECPrivateKey(receiveData(bytes: privateKeyBytes, count: privateKeyLength))
}

public enum WIFVersion: UInt8 {
    case mainnet = 0x80
    case testnet = 0xef
}

/// Convert an EC private key to a WIF private key.
public func toWIF(version: WIFVersion, isCompressed: Bool = true) -> (_ privateKey: ECPrivateKey) throws -> String {
    return { privateKey in
        var wifBytes: UnsafeMutablePointer<Int8>!
        var wifLength: Int = 0
        try privateKey.data.withUnsafeBytes { (privateKeyBytes: UnsafePointer<UInt8>) in
            if let error = BitcoinError(rawValue: _ecPrivateKeyToWIF(privateKeyBytes, privateKey.data.count, version.rawValue, isCompressed, &wifBytes, &wifLength)) {
                throw error
            }
        }
        return receiveString(bytes: wifBytes, count: wifLength)
    }
}

/// Convert an EC private key to a WIF private key.
public func toWIF(_ privateKey: ECPrivateKey) throws -> String {
    return try privateKey |> toWIF(version: .mainnet)
}

/// Convert a WIF private key to an EC private key.
public func wifToECPrivateKey(_ wif: String) throws -> ECPrivateKey {
    var privateKeyBytes: UnsafeMutablePointer<UInt8>!
    var privateKeyLength: Int = 0
    try wif.withCString { wifString in
        if let error = BitcoinError(rawValue: _wifToECPrivateKey(wifString, &privateKeyBytes, &privateKeyLength)) {
            throw error
        }
    }
    return try ECPrivateKey(receiveData(bytes: privateKeyBytes, count: privateKeyLength))
}
