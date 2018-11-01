//
//  TestEC.swift
//  Bitcoin_Tests
//
//  Created by Wolf McNally on 10/30/18.
//  Copyright © 2018 Blockchain Commons. All rights reserved.
//

import XCTest
import Bitcoin
import WolfPipe
import WolfStrings

class TestEC: XCTestCase {
    func testECNew() {
        XCTAssertNoThrow(try "baadf00dbaadf00dbaadf00dbaadf00d" |> base16Decode |> ecNew |> base16Encode == "8ed1d17dabce1fccbbe5e9bf008b318334e5bcc78eb9e7c1ea850b7eb0ddb9c8")
        XCTAssertThrowsError(try "baadf00dbaadf00d" |> base16Decode |> ecNew |> base16Encode == "won't happen") // seed too short
    }

    func testECToPublicKey() {
        XCTAssertNoThrow(try "4c721ccd679b817ea5e86e34f9d46abb1660a63955dde908702214eaab038475" |> base16Decode |> toECPrivateKey |> toECPublicKey |> base16Encode == "03ac9e60013853128b42a1324609bac2ccff6a0b4844b6301f1f552e15ee14c7a5")
        XCTAssertNoThrow(try "8ed1d17dabce1fccbbe5e9bf008b318334e5bcc78eb9e7c1ea850b7eb0ddb9c8" |> base16Decode |> toECPrivateKey |> toECPublicKey |> base16Encode == "0247140d2811498679fe9a0467a75ac7aa581476c102d27377bc0232635af8ad36")
        XCTAssertNoThrow(try "8ed1d17dabce1fccbbe5e9bf008b318334e5bcc78eb9e7c1ea850b7eb0ddb9c8" |> base16Decode |> toECPrivateKey |> toECUncompressedPublicKey |> base16Encode == "0447140d2811498679fe9a0467a75ac7aa581476c102d27377bc0232635af8ad36e87bb04f401be3b770a0f3e2267a6c3b14a3074f6b5ce4419f1fcdc1ca4b1cb6")
    }
}
