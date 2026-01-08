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
