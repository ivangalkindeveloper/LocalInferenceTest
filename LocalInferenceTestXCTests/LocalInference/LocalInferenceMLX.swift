import Foundation
import MLX
import MLXLMCommon

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
        try await Performer.run(
            modelId,
            "Respond",
            {
                try await session.respond(to: prompt)
            },
            { response in
                response
            }
        )
    }
    
    func prepareNER() {
        session = MLXLMCommon.ChatSession(
            model,
            instructions: """
            \(NERConfig.role)

            \(NERConfig.outputJsonExample)
            """,
        )
    }
    
    func NER(
        speech: String
    ) async throws -> NERResponse {
        let response = try await Performer.run(
            modelId,
            "NER",
            {
                try await session.respond(to: speech)
            },
            { response in
                response
            }
        )
        
        let data = Data(response.utf8)
        let decoded = try NERConfig.jsonDecoder.decode(NERResponse.self, from: data)
        return decoded
    }
    
    func clear() {
        session.clear()
    }
}
