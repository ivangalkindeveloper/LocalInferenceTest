import Foundation
import FoundationModels
import MLX
import MLXLMCommon

protocol LocalInferenceProtocol {
    func prepareRespond()
    
    func respond(
        prompt: String
    ) async throws -> String
    
    func prepareNER()
    
    func NER(
        speech: String
    ) async throws -> NERResponse
}

// MARK: FoundationModels -

@available(iOS 26.0, *)
final class LocalInferenceFoudationModels: LocalInferenceProtocol {
    private var session = LanguageModelSession()
    
    @FoundationModels.Generable
    struct Response {
        @FoundationModels.Guide(description: "")
        let patientName: String?
        @FoundationModels.Guide(description: "")
        let patientGender: Gender?
        @FoundationModels.Guide(description: "")
        let patientDateOfBirth: String?
        @FoundationModels.Guide(description: "")
        let patientHeight: Double?
        @FoundationModels.Guide(description: "")
        let patientWeight: Double?
        @FoundationModels.Guide(description: "")
        let patientComplaint: String?
        @FoundationModels.Guide(description: "")
        let researchDescription: String?
        @FoundationModels.Guide(description: "")
        let additionalData: String?
    }
    
    @FoundationModels.Generable
    enum Gender {
        case male
        case female
    }
    
    func prepareRespond() {
        session = LanguageModelSession()
    }
    
    func respond(
        prompt: String,
    ) async throws -> String {
        try await session.respond(to: prompt).content
    }
    
    func prepareNER() {
        session = LanguageModelSession(
            instructions: NERConfig.role
        )
    }
    
    func NER(
        speech: String
    ) async throws -> NERResponse {
        let response = try await session.respond(
            to: speech,
            generating: Response.self
        )
        
        return NERResponse.fromFoudationModels(
            response.content
        )
    }
}

// MARK: MLX -

final class LocalInferenceMLX: LocalInferenceProtocol {
    private let modelId: String
    private let model: MLXLMCommon.ModelContext
    private var session: MLXLMCommon.ChatSession
    
    init(
        modelId: String
    ) async throws {
        self.modelId = modelId
        print("LocalInferenceMLX - START LOADING \(modelId)")
        self.model = try await MLXLMCommon.loadModel(id: modelId)
        print("LocalInferenceMLX - COMPLETE LOADING \(modelId)")
        self.session = MLXLMCommon.ChatSession(model)
    }
    
    func prepareRespond() {
        session = MLXLMCommon.ChatSession(model)
    }
    
    func respond(
        prompt: String
    ) async throws -> String {
        try await session.respond(to: prompt)
    }
    
    func prepareNER() {
        session = MLXLMCommon.ChatSession(
            model,
            instructions: """
            \(NERConfig.role)

            \(NERConfig.jsonFormat)
            """,
        )
    }
    
    func NER(
        speech: String
    ) async throws -> NERResponse {
        let response = try await session.respond(to: speech)
        let data = Data(response.utf8)
        let decoded = try JSONDecoder().decode(NERResponse.self, from: data)
        return decoded
    }
    
    func clear() {
        session.clear()
    }
}
