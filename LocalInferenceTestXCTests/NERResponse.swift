
import Foundation

struct NERResponse: Decodable {
    
    enum Gender: Decodable {
        case male
        case female
        
        @available(iOS 26.0, *)
        static func fromFoudationModels(
            _ response: LocalInferenceFoudationModels.Gender?
        ) -> Self? {
            switch response {
            case .male:
                return .male
            case .female:
                return .female
            case nil:
                return nil
            }
        }
        
    }

    let patientName: String?
    let patientGender: Gender?
    let patientDateOfBirth: Date?
    let patientHeight: Double?
    let patientWeight: Double?
    let patientComplaint: String?
    let researchDescription: String?
    let additionalData: String?
    
    @available(iOS 26.0, *)
    static func fromFoudationModels(
        _ response: LocalInferenceFoudationModels.Response
    ) -> Self {
        NERResponse(
            patientName: response.patientName,
            patientGender: Gender.fromFoudationModels(response.patientGender),
            patientDateOfBirth: DateFormatter().date(from: response.patientDateOfBirth ?? ""),
            patientHeight: response.patientHeight,
            patientWeight: response.patientWeight,
            patientComplaint: response.patientComplaint,
            researchDescription: response.researchDescription,
            additionalData: response.additionalData
        )
    }
    
}
