import Foundation
import FoundationModels

@available(iOS 26.0, *)
final class LocalInferenceFoudationModels: LocalInferenceProtocol {
    private var session = LanguageModelSession()
    
    @FoundationModels.Generable
    struct Response {
        @FoundationModels.Guide(description: "Patient name, number, or nickname")
        let patientName: String?
        
        @FoundationModels.Guide(description: "Patient gender")
        let patientGender: Gender?
        
        @FoundationModels.Guide(description: "Patient date of birth in the following format \(NERConfig.dateFormat)")
        let patientDateOfBirth: String?
        
        @FoundationModels.Guide(description: "Patient height in centimeters")
        let patientHeightCM: Double?
        
        @FoundationModels.Guide(description: "Patient weight in kilograms")
        let patientWeightKG: Double?
        
        @FoundationModels.Guide(description: "Patient complaints")
        let patientComplaint: String?
        
        @FoundationModels.Guide(description: "Patient examination details")
        let researchDescription: String?
        
        @FoundationModels.Guide(description: "Additional patient-independent examination details, such as device model, sensor types, and number of photographs and videos")
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
        try await Performer.run(
            "FoundationModels",
            "Respond",
            {
                try await session.respond(
                    to: prompt
                ).content
            },
            { response in
                response
            }
        )
    }
    
    func prepareNER() {
        session = LanguageModelSession(
            instructions: """
            \(NERConfig.role)

            \(NERConfig.answerExamples)
            """,
        )
    }
    
    func NER(
        speech: String
    ) async throws -> NERResponse {
        let response = try await Performer.run(
            "FoundationModels",
            "NER",
            {
                try await session.respond(
                    to: speech,
                    generating: Response.self
                )
            },
            { response in
                "\(response)"
            }
        )
        
        return NERResponse.fromFoudationModels(
            response.content
        )
    }
}
