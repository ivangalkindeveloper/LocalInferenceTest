import Foundation

struct NERResponse: Codable {
    enum Gender: String, Codable {
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
    let patientHeightCM: Double?
    let patientWeightKG: Double?
    let patientComplaint: String?
    let researchDescription: String?
    let additionalData: String?
    
    @available(iOS 26.0, *)
    static func fromFoudationModels(
        _ response: LocalInferenceFoudationModels.Response
    ) -> Self {
        NERResponse(
            patientName: response.patientName,
            patientGender: Gender.fromFoudationModels(
                response.patientGender
            ),
            patientDateOfBirth: NERConfig.dateFormatter.date(
                from: response.patientDateOfBirth ?? ""
            ),
            patientHeightCM: response.patientHeightCM,
            patientWeightKG: response.patientWeightKG,
            patientComplaint: response.patientComplaint,
            researchDescription: response.researchDescription,
            additionalData: response.additionalData
        )
    }
}
