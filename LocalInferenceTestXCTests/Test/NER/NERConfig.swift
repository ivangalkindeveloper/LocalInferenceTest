import Foundation

enum NERConfig {
    static let dateFormat: String = "YYYY-MM-DD"
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter
    }()
    static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    static let entities: String = """
        patient name,
        patient gender,
        patient date of birth in \(dateFormat) format,
        patient height,
        patient weight,
        patient complaint,
        research description,
        additional information
        """
    static let role: String =
        """
        You are a model parsing a medical study text obtained by a doctor's dictation.
        Dictation text must be parsed into the following entitiesabout the medical research performed: \(entities).
        Don't invent anything of your own or add from the examples below, the main task is to parse only the transmitted dictated text.
        Each entity must be text-normalized — split into logical sentences, restore punctuation, correct slurred speech, convert word forms to literary forms, and correct syntax and spelling errors, as the text is dictated by a doctor's voice.
        Ignore noise, filler words, dictation errors, and incomplete or repeated phrases in the parsed text.
        No guesswork when parsing entities — if there is no data, return field with null.
        """
    static let answerExamples: String = """
        Example of parsing:
        PatientName": "Jhon"
        PatientGender": "male" / "female"
        PatientDateOfBirth": "1994-03-28" - Format \(dateFormat)
        PatientHeightCM": 174.0
        PatientWeightKG": 68.0
        PatientComplaint": "Intermittent abdominal pain, difficulty swallowing."
        ResearchDescription": "An abdominal ultrasound and a renal ultrasound were performed with preliminary preparation. The examination was complicated by increased gas production."
        AdditionalData": "A 3-5 MHz convex probe and a 7.5 MHz linear probe were used. 12 images and 3 video loops were saved."
        """
    static let outputJsonExample: String =
        """
        The response must be returned in the JSON format described below, nothing else is required.
        Don't invent other fields, the format should be only this one.
        JSON format:
        {
            "patientName": "Jhon",
            "patientGender": "male",
            "patientDateOfBirth": "1994-03-28",
            "patientHeightCM": 174.0,
            "patientWeightKG": 68.0,
            "patientComplaint": "Intermittent abdominal pain, difficulty swallowing.",
            "researchDescription": "An abdominal ultrasound and a renal ultrasound were performed with preliminary preparation. The examination was complicated by increased gas production.",
            "additionalData": "A 3-5 MHz convex probe and a 7.5 MHz linear probe were used. 12 images and 3 video loops were saved."
        }
        """
}
