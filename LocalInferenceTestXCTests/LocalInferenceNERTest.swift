import XCTest
@testable import LocalInferenceTest

final class LocalInferenceNERTest: XCTestCase {
    
    func test() async throws {
        try await nerFoundationModels()

        try await nerMLX(Model.`Llama-3.2-1B-Instruct-4bit`)
        try await nerMLX(Model.`Llama-3.2-3B-Instruct-4bit`)
        
        try await nerMLX(Model.`gemma-2-2b-it-4bit`)
        try await nerMLX(Model.`gemma-3-1b-it-4bit`)
        try await nerMLX(Model.`gemma-3-4b-it-4bit`)
        
        try await nerMLX(Model.`Qwen2.5-0.5B-Instruct-4bit`)
        try await nerMLX(Model.`Qwen2.5-1.5B-Instruct-4bit`)
        try await nerMLX(Model.`Qwen2.5-3B-Instruct-4bit`)
        
        try await nerMLX(Model.`Phi-3-mini-128k-instruct-4bit`)
        try await nerMLX(Model.`Phi-3-mini-4k-instruct-4bit`)
        try await nerMLX(Model.`Phi-4-mini-instruct-4bit`)
    }
    
    func assertNER(
        _ response: NERResponse
    ) throws -> Void {
        XCTAssert(response.patientName != nil)
        XCTAssert(response.patientName?.isEmpty == false)
        XCTAssert(response.patientGender != nil)
        XCTAssert(response.patientDateOfBirth != nil)
        XCTAssert(response.patientHeight != nil)
        XCTAssert(response.patientWeight != nil)
        XCTAssert(response.patientComplaint != nil)
        XCTAssert(response.patientComplaint?.isEmpty == false)
        XCTAssert(response.researchDescription != nil)
        XCTAssert(response.researchDescription?.isEmpty == false)
        XCTAssert(response.additionalData != nil)
        XCTAssert(response.additionalData?.isEmpty == false)
    }
    
    func nerFoundationModels() async throws {
        if #available(iOS 26.0, *) {
            let model = LocalInferenceFoudationModels()
            let response = try await Performer.run(
                "FoundationModels",
                "NER",
                {
                    try await model.NER(speech: Prompt.nerSpeech)
                },
                { response in
                    "\(response)"
                }
            )
            try assertNER(response)
        }
    }
    
    func nerMLX(
        _ modelId: String,
    ) async throws -> Void {
        let model = try await LocalInferenceMLX(modelId: modelId)
        let response = try await Performer.run(
            modelId,
            "NER",
            {
                try await model.NER(speech: Prompt.nerSpeech)
            },
            { response in
                "\(response)"
            }
        )
        try assertNER(response)
    }

}
