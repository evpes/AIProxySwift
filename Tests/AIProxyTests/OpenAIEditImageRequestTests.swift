//
//  OpenAIEditImageRequestTests.swift
//  AIProxy
//
//  Created by Lou Zell on 8/4/25.
//

import XCTest
@testable import AIProxy

final class OpenAIEditImageRequestTests: XCTestCase {

    func testRequestBodyIsEncodable() throws {
        let boundary = "my-boundary"
        let crlf = "\r\n"
        let image = createImage(width: 1, height: 1)
        let jpegData = AIProxy.encodeImageAsJpeg(image: image, compressionQuality: 1.0)!

        let requestBody = OpenAICreateImageEditRequestBody(
            images: [.jpeg(jpegData)],
            prompt: "Change the boat mast to red",
            background: .transparent,
            inputFidelity: .high,
            model: .gptImage1,
            outputFormat: .png
        )
        var expectedEncoding = Data()

        let fileIntro = """
        --\(boundary)
        Content-Disposition: form-data; name="image[]"; filename="tmpfile0"
        Content-Type: image/jpeg


        """.replacingOccurrences(of: "\n", with: crlf)

        expectedEncoding.append(Data(fileIntro.utf8))
        expectedEncoding.append(jpegData)
        expectedEncoding.append(Data(crlf.utf8))

        let remainingArguments = """
        --\(boundary)
        Content-Disposition: form-data; name="prompt"

        Change the boat mast to red
        --\(boundary)
        Content-Disposition: form-data; name="background"

        transparent
        --\(boundary)
        Content-Disposition: form-data; name="input_fidelity"

        high
        --\(boundary)
        Content-Disposition: form-data; name="model"

        gpt-image-1
        --\(boundary)
        Content-Disposition: form-data; name="output_format"

        png
        --\(boundary)--
        """.replacingOccurrences(of: "\n", with: crlf)
        expectedEncoding.append(Data(remainingArguments.utf8))

        XCTAssertEqual(
            expectedEncoding,
            formEncode(requestBody, boundary)
        )
    }

    func testGPTImage2_5RequestBodyIsEncodable() throws {
        let boundary = "my-boundary"
        let crlf = "\r\n"
        let image = createImage(width: 1, height: 1)
        let jpegData = AIProxy.encodeImageAsJpeg(image: image, compressionQuality: 1.0)!

        let requestBody = OpenAICreateImageEditRequestBody(
            images: [.jpeg(jpegData)],
            prompt: "Turn this photo into a Renaissance oil painting",
            model: .gptImage2_5Sunburst,
            outputFormat: .jpeg,
            quality: .xhigh,
            size: "1024x1536"
        )
        var expectedEncoding = Data()

        let fileIntro = """
        --\(boundary)
        Content-Disposition: form-data; name="image[]"; filename="tmpfile0"
        Content-Type: image/jpeg


        """.replacingOccurrences(of: "\n", with: crlf)

        expectedEncoding.append(Data(fileIntro.utf8))
        expectedEncoding.append(jpegData)
        expectedEncoding.append(Data(crlf.utf8))

        let remainingArguments = """
        --\(boundary)
        Content-Disposition: form-data; name="prompt"

        Turn this photo into a Renaissance oil painting
        --\(boundary)
        Content-Disposition: form-data; name="model"

        gpt-image-2.5-sunburst
        --\(boundary)
        Content-Disposition: form-data; name="output_format"

        jpeg
        --\(boundary)
        Content-Disposition: form-data; name="quality"

        xhigh
        --\(boundary)
        Content-Disposition: form-data; name="size"

        1024x1536
        --\(boundary)--
        """.replacingOccurrences(of: "\n", with: crlf)
        expectedEncoding.append(Data(remainingArguments.utf8))

        XCTAssertEqual(
            expectedEncoding,
            formEncode(requestBody, boundary)
        )
    }
}
