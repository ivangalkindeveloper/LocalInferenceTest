final class Model {
    static let `Llama-3.2-1B-Instruct-4bit`: String = "mlx-community/Llama-3.2-1B-Instruct-4bit"
    static let `Llama-3.2-3B-Instruct-4bit`: String = "mlx-community/Llama-3.2-3B-Instruct-4bit"
    
    static let `gemma-2-2b-it-4bit`: String = "mlx-community/gemma-2-2b-it-4bit"
    static let `gemma-3-1b-it-4bit`: String = "mlx-community/gemma-3-1b-it-4bit"
    static let `gemma-3-4b-it-4bit`: String = "mlx-community/gemma-3-4b-it-4bit"
    
    static let `Qwen2.5-0.5B-Instruct-4bit`: String = "mlx-community/Qwen2.5-0.5B-Instruct-4bit"
    static let `Qwen2.5-1.5B-Instruct-4bit`: String = "mlx-community/Qwen2.5-1.5B-Instruct-4bit"
    static let `Qwen2.5-3B-Instruct-4bit`: String = "mlx-community/Qwen2.5-3B-Instruct-4bit"
    
    static let `Phi-3-mini-128k-instruct-4bit`: String = "mlx-community/Phi-3-mini-128k-instruct-4bit"
    static let `Phi-3-mini-4k-instruct-4bit`: String = "mlx-community/Phi-3-mini-4k-instruct-4bit"
    static let `Phi-4-mini-instruct-4bit`: String = "mlx-community/Phi-4-mini-instruct-4bit"
}

final class Prompt {
    static let simple = """
        There are three switches in a room.
        One of them turns on a lamp in the next room.
        You can only enter the room with the lamp once.
        How can you determine which switch turns on the lamp?
        Explain the solution step by step.
        """
    static let nerSpeech = "patient Ivan male born March 28 1994 height 180 cm 80 kg complaints periodic abdominal pain discomfort when swallowing pain in the left abdomen and a tingling sensation in the right abdomen an ultrasound examination of the abdominal organs and an ultrasound examination of the kidneys were performed no additional information about technical photographic evidence was found a linear array with a frequency of 7.5 megahertz was used 12 images of the study were saved"
}

final class NERConfig {
    static let role: String =
        """
        You are a model parsing a medical study text obtained by a doctor's dictation.
        This text must be parsed into the following entities: patient name, patient gender, patient date of birth, patient height, patient weight, patient complaint, research description, and additional information about the medical research performed.
        Ignore noise, filler words, dictation errors, and incomplete or repeated phrases in the parsed text. No guesswork; if there is no data, enter null.
        Each parsed section of entities must be edited for syntax and spelling errors, as the text is simply dictated by voice.
        The response must be returned in the JSON format described below, nothing else is required.
        """
    
    static let jsonFormat: String =
        """
        JSON format:
        {
            "patientName": "Patient name",
            "patientGender": "male / female",
            "patientDateOfBirth": "1994-03-28 12:00:00+0000",
            "patientHeight": 180.0,
            "patientWeight": 80.0,
            "patientComplaint": "Patient complaint",
            "researchDescription": "Research description",
            "additionalData": "Some additional data"
        }
        """
}
