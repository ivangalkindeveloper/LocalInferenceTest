import Foundation
import FoundationModels
import MLXLMCommon
import MLX

protocol LocalInferenceTestProtocol {
    func simple(
        prompt: String
    ) async throws -> String
    
    func ner(
        speech: String
    ) async throws -> NERResponse
}


// MARK: - FoundationModels
@available(iOS 26.0, *)
final class LocalInferenceTestFoudationModels: LocalInferenceTestProtocol {
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
    
    func simple(
        prompt: String
    ) async throws -> String {
        let session = LanguageModelSession()
        
        let response = try await session.respond(to: prompt)
        
        return response.content
    }
    
    func ner(
        speech: String
    ) async throws -> NERResponse {
        let session = LanguageModelSession(
            instructions: NERConfig.role
        )
        
        let response = try await session.respond(
            to: Prompt.simple,
            generating: Response.self
        )
        
        return NERResponse.fromFoudationModels(
            response.content
        )
    }
}


// MARK: - MLX
final class LocalInferenceTestMLX: LocalInferenceTestProtocol {
    let model: MLXLMCommon.ModelContext
    
    init(
        modelId: String
    ) async throws {
        self.model = try await MLXLMCommon.loadModel(
            id: modelId
        )
    }
    
    func simple(
        prompt: String
    ) async throws -> String {
        let session = MLXLMCommon.ChatSession(model)
        
        let response = try await session.respond(to: prompt)
        
        return response
    }
    
    func ner(
        speech: String
    ) async throws -> NERResponse {
        let session = MLXLMCommon.ChatSession(
            model,
            instructions: """
            \(NERConfig.role)

            \(NERConfig.jsonFormat)
            """,
        )

        let response = try await session.respond(to: speech,)
        
        let data = Data(response.utf8)
        let decoded = try JSONDecoder().decode(NERResponse.self, from: data)
        return decoded
    }
}
