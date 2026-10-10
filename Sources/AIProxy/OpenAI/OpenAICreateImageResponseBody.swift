//
//  OpenAICreateImageResponseBody.swift
//  AIProxy
//
//  Created by Lou Zell on 3/11/25.
//

import Foundation

/// Response body for the 'Create image' endpoint:
/// https://platform.openai.com/docs/api-reference/images/create
nonisolated public struct OpenAICreateImageResponseBody: Decodable, Sendable {
    /// A list of generated images returned from the 'Create Image' endpoint
    public let data: [ImageData]

    /// Token usage information for the image generation. Only returned for the GPT image models.
    public let usage: Usage?

    public init(data: [ImageData], usage: Usage? = nil) {
        self.data = data
        self.usage = usage
    }
}

// MARK: -
extension OpenAICreateImageResponseBody {
    /// https://platform.openai.com/docs/api-reference/images/object
    nonisolated public struct ImageData: Decodable, Sendable {
        /// The base64-encoded JSON of the generated image, if `responseFormat` on OpenAICreateImageRequestBody is `b64_json`.
        public let b64JSON: String?

        /// The prompt that was used to generate the image, if there was any revision to the prompt.
        public let revisedPrompt: String?

        /// The URL of the generated image,  if `responseFormat` on OpenAICreateImageRequestBody is `url` (default).
        public let url: URL?

        public init(b64JSON: String?, revisedPrompt: String?, url: URL?) {
            self.b64JSON = b64JSON
            self.revisedPrompt = revisedPrompt
            self.url = url
        }

        enum CodingKeys: String, CodingKey {
            case b64JSON = "b64_json"
            case revisedPrompt = "revised_prompt"
            case url
        }
    }
}

// MARK: -
extension OpenAICreateImageResponseBody {
    /// https://platform.openai.com/docs/api-reference/images/object#images/object-usage
    nonisolated public struct Usage: Decodable, Sendable {
        /// The number of tokens (images and text) in the input prompt.
        public let inputTokens: Int?

        /// The input tokens detailed information for the image generation.
        public let inputTokensDetails: InputTokensDetails?

        /// The number of image tokens in the output image.
        public let outputTokens: Int?

        /// The total number of tokens (images and text) used for the image generation.
        public let totalTokens: Int?

        public init(
            inputTokens: Int?,
            inputTokensDetails: InputTokensDetails?,
            outputTokens: Int?,
            totalTokens: Int?
        ) {
            self.inputTokens = inputTokens
            self.inputTokensDetails = inputTokensDetails
            self.outputTokens = outputTokens
            self.totalTokens = totalTokens
        }

        private enum CodingKeys: String, CodingKey {
            case inputTokens = "input_tokens"
            case inputTokensDetails = "input_tokens_details"
            case outputTokens = "output_tokens"
            case totalTokens = "total_tokens"
        }
    }

    nonisolated public struct InputTokensDetails: Decodable, Sendable {
        /// The number of image tokens in the input prompt.
        public let imageTokens: Int?

        /// The number of text tokens in the input prompt.
        public let textTokens: Int?

        public init(imageTokens: Int?, textTokens: Int?) {
            self.imageTokens = imageTokens
            self.textTokens = textTokens
        }

        private enum CodingKeys: String, CodingKey {
            case imageTokens = "image_tokens"
            case textTokens = "text_tokens"
        }
    }
}
