import XCTest
@testable import LocalInferenceTest

final class NERTest: XCTestCase {
    
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
//        try await nerFoundationModels()

//        try await nerMLX(Model.`mlx-Llama-3.2-1B-Instruct-4bit`)
//        try await nerMLX(Model.`mlx-Llama-3.2-3B-Instruct-4bit`)

//        try await nerMLX(Model.`mlx-gemma-2-2b-it-4bit`)
//        try await nerMLX(Model.`mlx-gemma-3-1b-it-4bit`)
//        try await nerMLX(Model.`mlx-gemma-3-4b-it-4bit`)

//        try await nerMLX(Model.`mlx-Qwen2.5-0.5B-Instruct-4bit`)
//        try await nerMLX(Model.`mlx-Qwen2.5-1.5B-Instruct-4bit`)
//        try await nerMLX(Model.`mlx-Qwen2.5-3B-Instruct-4bit`)

//        try await nerMLX(Model.`mlx-Phi-3-mini-128k-instruct-4bit`)
//        try await nerMLX(Model.`mlx-Phi-3-mini-4k-instruct-4bit`)
        try await nerMLX(Model.`mlx-Phi-4-mini-instruct-4bit`)
    }
    
    func assertNER(
        _ response: NERResponse
    ) throws -> Void {
        XCTAssert(response.patientName != nil)
        XCTAssert(response.patientName?.isEmpty == false)
        XCTAssert(response.patientGender != nil)
        XCTAssert(response.patientDateOfBirth != nil)
        XCTAssert(response.patientHeightCM != nil)
        XCTAssert(response.patientWeightKG != nil)
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
            model.prepareNER()
            let response = try await model.NER(speech: Prompt.nerSpeech)
            try assertNER(response)
        }
    }
    
    func nerMLX(
        _ modelId: String,
    ) async throws -> Void {
        let model = try await LocalInferenceMLX(modelId: modelId)
        model.prepareNER()
        let response = try await model.NER(speech: Prompt.nerSpeech)
        model.clear()
        try assertNER(response)
    }

}
