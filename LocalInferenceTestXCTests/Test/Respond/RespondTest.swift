@testable import LocalInferenceTest
import os
import XCTest

final class RespondTest: XCTestCase {
    
//    override func setUp() async throws {
//        try await MLXCache.cache(
//            models: [
//                Model.`mlx-Llama-3.2-1B-Instruct-4bit`,
//                Model.`mlx-Llama-3.2-3B-Instruct-4bit`,
//
//                Model.`mlx-gemma-2-2b-it-4bit`,
//                Model.`mlx-gemma-3-1b-it-4bit`,
//                Model.`mlx-gemma-3-4b-it-4bit`,
//
//                Model.`mlx-Qwen2.5-0.5B-Instruct-4bit`,
//                Model.`mlx-Qwen2.5-1.5B-Instruct-4bit`,
//                Model.`mlx-Qwen2.5-3B-Instruct-4bit`,
//
//                Model.`mlx-Phi-3-mini-128k-instruct-4bit`,
//                Model.`mlx-Phi-3-mini-4k-instruct-4bit`,
//                Model.`mlx-Phi-4-mini-instruct-4bit`,
//            ]
//        )
//    }

    func test() async throws {
//        try await respondFoundationModels()

//        try await respondMLX(Model.`mlx-Llama-3.2-1B-Instruct-4bit`)
//        try await respondMLX(Model.`mlx-Llama-3.2-3B-Instruct-4bit`)

//        try await respondMLX(Model.`mlx-gemma-2-2b-it-4bit`)
//        try await respondMLX(Model.`mlx-gemma-3-1b-it-4bit`)
//        try await respondMLX(Model.`mlx-gemma-3-4b-it-4bit`)

//        try await respondMLX(Model.`mlx-Qwen2.5-0.5B-Instruct-4bit`)
//        try await respondMLX(Model.`mlx-Qwen2.5-1.5B-Instruct-4bit`)
//        try await respondMLX(Model.`mlx-Qwen2.5-3B-Instruct-4bit`)

//        try await respondMLX(Model.`mlx-Phi-3-mini-128k-instruct-4bit`)
//        try await respondMLX(Model.`mlx-Phi-3-mini-4k-instruct-4bit`)
//        try await respondMLX(Model.`mlx-Phi-4-mini-instruct-4bit`)
    }

    func respondFoundationModels() async throws {
        if #available(iOS 26.0, *) {
            let model = LocalInferenceFoudationModels()
            model.prepareRespond()
            let response = try await model.respond(prompt: Prompt.respond)
            XCTAssert(response.isEmpty == false)
        }
    }

    func respondMLX(
        _ modelId: String,
    ) async throws {
        let model = try await LocalInferenceMLX(modelId: modelId)
        model.prepareRespond()
        let response = try await model.respond(prompt: Prompt.respond)
        model.clear()
        XCTAssert(response.isEmpty == false)
    }
}
