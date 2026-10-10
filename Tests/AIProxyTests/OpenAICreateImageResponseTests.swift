//
//  OpenAICreateImageResponseTests.swift
//  AIProxy
//
//  Created by Lou Zell on 4/23/25.
//

import XCTest
@testable import AIProxy

final class OpenAICreateImageResponseTests: XCTestCase {

    func testResponseBodyIsDecodable() throws {
        let sampleResponse = """
        {
          "created": 1745433403,
          "data": [
            {
              "b64_json": "<snip>"
            }
          ],
          "usage": {
            "input_tokens": 8,
            "input_tokens_details": {
              "image_tokens": 0,
              "text_tokens": 8
            },
            "output_tokens": 1584,
            "total_tokens": 1592
          }
        }
        """
        let res = try OpenAICreateImageResponseBody.deserialize(from: sampleResponse)
        XCTAssertEqual("<snip>", res.data.first?.b64JSON)
        XCTAssertEqual(8, res.usage?.inputTokens)
        XCTAssertEqual(0, res.usage?.inputTokensDetails?.imageTokens)
        XCTAssertEqual(8, res.usage?.inputTokensDetails?.textTokens)
        XCTAssertEqual(1584, res.usage?.outputTokens)
        XCTAssertEqual(1592, res.usage?.totalTokens)
    }

    func testResponseBodyWithoutUsageIsDecodable() throws {
        let sampleResponse = """
        {
          "created": 1745433403,
          "data": [
            {
              "url": "https://example.com/image.png"
            }
          ]
        }
        """
        let res = try OpenAICreateImageResponseBody.deserialize(from: sampleResponse)
        XCTAssertEqual("https://example.com/image.png", res.data.first?.url?.absoluteString)
        XCTAssertNil(res.usage)
    }
}
