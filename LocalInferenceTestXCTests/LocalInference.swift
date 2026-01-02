import Foundation
import FoundationModels
import MLXLMCommon
import MLX

protocol LocalInferenceProtocol {
    func respond(
        prompt: String
    ) async throws -> String
    
    func ner(
        speech: String
    ) async throws -> NERResponse
}


// MARK: FoundationModels -
@available(iOS 26.0, *)
final class LocalInferenceFoudationModels: LocalInferenceProtocol {
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
    
    func respond(
        prompt: String
    ) async throws -> String {
        let session = LanguageModelSession()
        
        let response = try await Performer().run(
            "FoundationModels",
            "Respond",
            {
               try await session.respond(to: prompt)
            },
            {
                $0.content
            }
        )
        
        return response.content
    }
    
    func ner(
        speech: String
    ) async throws -> NERResponse {
        let session = LanguageModelSession(
            instructions: NERConfig.role
        )
        
        let response = try await Performer().run(
            "FoundationModels",
            "NER",
            {
               try await session.respond(
                   to: speech,
                   generating: Response.self
               )
            },
            {
                "\($0.content)"
            }
        )
        
        return NERResponse.fromFoudationModels(
            response.content
        )
    }
}


// MARK: MLX -
final class LocalInferenceMLX: LocalInferenceProtocol {
    let modelId: String
    let model: MLXLMCommon.ModelContext
    
    init(
        modelId: String
    ) async throws {
        self.modelId = modelId
        self.model = try await MLXLMCommon.loadModel(
            id: modelId
        )
    }
    
    func respond(
        prompt: String
    ) async throws -> String {
        let session = MLXLMCommon.ChatSession(model)
        
        let response = try await Performer().run(
            modelId,
            "Respond",
            {
                try await session.respond(to: prompt)
            },
            {
                $0
            }
        )
        
        session.clear()
        
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
        
        let response = try await Performer().run(
            modelId,
            "NER",
            {
                try await session.respond(to: speech)
            },
            {
                $0
            }
        )
        
        session.clear()
        
        let data = Data(response.utf8)
        let decoded = try JSONDecoder().decode(NERResponse.self, from: data)
        return decoded
    }
}
