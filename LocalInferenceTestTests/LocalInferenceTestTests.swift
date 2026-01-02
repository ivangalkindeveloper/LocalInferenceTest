import Testing
@testable import LocalInferenceTest

struct LocalInferenceTestTests {
    
    func printing(
        _ test: String,
        _ model: String,
        _ response: String
    ) -> Void {
        print("""
            
            \(model):
            \(response)
            
            """)
    }
    
    
    
    // MARK: Simple -
    @Test func simple() async throws {
        try await simple_FoundationModels()
        try await simple_MLX_Llama()
        try await simple_MLX_Gemma()
        try await simple_MLX_Qwen()
        try await simple_MLX_Phi()
    }
    
    @Test func simple_FoundationModels() async throws {
        let foundationModels = await LocalInferenceTestFoudationModels()
        let response = try await foundationModels.simple(prompt: Prompt.simple)
        #require(response.isEmpty == false)
        printing("Simple", "FoundationModels", response)
    }
    
    func simpleMLXTest(
        _ modelId: String,
    ) async throws -> Void {
        let model = try await LocalInferenceTestMLX(modelId: modelId)
        let response = try await model.simple(prompt: Prompt.simple)
        #require(response.isEmpty == false)
        printing("Simple", modelId, response)
    }

    @Test func simple_MLX_Llama() async throws {
        try await simpleMLXTest(Model.`Llama-3.2-1B-Instruct-4bit`)
        try await simpleMLXTest(Model.`Llama-3.2-3B-Instruct-4bit`)
    }
    
    @Test func simple_MLX_Gemma() async throws {
        try await simpleMLXTest(Model.`gemma-2-2b-it-4bit`)
        try await simpleMLXTest(Model.`gemma-3-1b-it-4bit`)
        try await simpleMLXTest(Model.`gemma-3-4b-it-4bit`)
    }
    
    @Test func simple_MLX_Qwen() async throws {
        try await simpleMLXTest(Model.`Qwen2.5-0.5B-Instruct-4bit`)
        try await simpleMLXTest(Model.`Qwen2.5-1.5B-Instruct-4bit`)
        try await simpleMLXTest(Model.`Qwen2.5-3B-Instruct-4bit`)
    }
    
    @Test func simple_MLX_Phi() async throws {
        try await simpleMLXTest(Model.`Phi-3-mini-128k-instruct-4bit`)
        try await simpleMLXTest(Model.`Phi-3-mini-4k-instruct-4bit`)
        try await simpleMLXTest(Model.`Phi-4-mini-instruct-4bit`)
    }
    
    
    
    // MARK: NER -
    @Test func startNER() async throws {
        try await ner_FoundationModels()
        try await ner_MLX_Llama()
        try await ner_MLX_Gemma()
        try await ner_MLX_Qwen()
        try await ner_MLX_Phi()
    }
    
    func validateNER(
        _ response: NERResponse
    ) throws -> Void {
        #require(response.patientName != nil)
        #require(response.patientName?.isEmpty == false)
        #require(response.patientGender != nil)
        #require(response.patientDateOfBirth != nil)
        #require(response.patientHeight != nil)
        #require(response.patientWeight != nil)
        #require(response.patientComplaint != nil)
        #require(response.patientComplaint?.isEmpty == false)
        #require(response.researchDescription != nil)
        #require(response.researchDescription?.isEmpty == false)
        #require(response.additionalData != nil)
        #require(response.additionalData?.isEmpty == false)
    }
    
    @Test func ner_FoundationModels() async throws {
        let foundationModels = await LocalInferenceTestFoudationModels()
        let response = try await foundationModels.ner(speech: Prompt.nerSpeech)
        try validateNER(response)
        printing("NER", "FoundationModels", "\(response)")
    }
    
    func nerMLX(
        _ modelId: String,
    ) async throws -> Void {
        let model = try await LocalInferenceTestMLX(modelId: modelId)
        let response = try await model.ner(speech: Prompt.nerSpeech)
        try validateNER(response)
        printing("Simple", modelId, "\(response)")
    }
    
    @Test func ner_MLX_Llama() async throws {
        try await nerMLX(Model.`Llama-3.2-1B-Instruct-4bit`)
        try await nerMLX(Model.`Llama-3.2-3B-Instruct-4bit`)
    }
    
    @Test func ner_MLX_Gemma() async throws {
        try await nerMLX(Model.`gemma-2-2b-it-4bit`)
        try await nerMLX(Model.`gemma-3-1b-it-4bit`)
        try await nerMLX(Model.`gemma-3-4b-it-4bit`)
    }
    
    @Test func ner_MLX_Qwen() async throws {
        try await nerMLX(Model.`Qwen2.5-0.5B-Instruct-4bit`)
        try await nerMLX(Model.`Qwen2.5-1.5B-Instruct-4bit`)
        try await nerMLX(Model.`Qwen2.5-3B-Instruct-4bit`)
    }
    
    @Test func ner_MLX_Phi() async throws {
        try await nerMLX(Model.`Phi-3-mini-128k-instruct-4bit`)
        try await nerMLX(Model.`Phi-3-mini-4k-instruct-4bit`)
        try await nerMLX(Model.`Phi-4-mini-instruct-4bit`)
    }
}
