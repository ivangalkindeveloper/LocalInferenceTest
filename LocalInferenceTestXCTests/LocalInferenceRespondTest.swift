import XCTest
import os
@testable import LocalInferenceTest

final class LocalInferenceRespondTest: XCTestCase {

    func test() async throws {
        try await respondFoundationModels()

        try await respondMLX(Model.`Llama-3.2-1B-Instruct-4bit`)
        try await respondMLX(Model.`Llama-3.2-3B-Instruct-4bit`)

        try await respondMLX(Model.`gemma-2-2b-it-4bit`)
        try await respondMLX(Model.`gemma-3-1b-it-4bit`)
        try await respondMLX(Model.`gemma-3-4b-it-4bit`)

        try await respondMLX(Model.`Qwen2.5-0.5B-Instruct-4bit`)
        try await respondMLX(Model.`Qwen2.5-1.5B-Instruct-4bit`)
        try await respondMLX(Model.`Qwen2.5-3B-Instruct-4bit`)

        try await respondMLX(Model.`Phi-3-mini-128k-instruct-4bit`)
        try await respondMLX(Model.`Phi-3-mini-4k-instruct-4bit`)
        try await respondMLX(Model.`Phi-4-mini-instruct-4bit`)
    }
    
    func respondFoundationModels() async throws {
        let model = LocalInferenceFoudationModels()
        model.prepareRespond()
        let response = try await Performer.run(
            "FoundationModels",
            "Respond",
            {
                try await model.respond(prompt: Prompt.respond)
            },
            { response in
                response
            }
        )
        XCTAssert(response.isEmpty == false)
    }
    
    func respondMLX(
        _ modelId: String,
    ) async throws -> Void {
        let model = try await LocalInferenceMLX(modelId: modelId)
        model.prepareRespond()
        let response = try await Performer.run(
            modelId,
            "Respond",
            {
                try await model.respond(prompt: Prompt.respond)
            },
            { response in
                response
            }
        )
        model.clear()
        XCTAssert(response.isEmpty == false)
    }

}
