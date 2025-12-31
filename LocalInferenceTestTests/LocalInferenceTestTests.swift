import Testing
@testable import LocalInferenceTest

struct LocalInferenceTestTests {

    
    
    @Test func startSimple() async throws {
        let start = ContinuousClock.now
        
        // MARK: - FoundationModels
        let foundationModels = await LocalInferenceTestFoudationModels()
        let response0 = try await foundationModels.simple(prompt: Prompt.simple)
        print("""
            
            FoundationModels:
            \(response0)
            
            """)

        
        
        // MARK: - MLX: Qwen2.5-0.5B-Instruct-4bit
        let `mlx_Qwen2.5-0.5B-Instruct-4bit` = try await LocalInferenceTestMLX(modelId: Model.`Qwen2.5-0.5B-Instruct-4bit`)
        let response1 = try await `mlx_Qwen2.5-0.5B-Instruct-4bit`.simple(prompt: Prompt.simple)
        print("""
            
            Qwen2.5-0.5B-Instruct-4bit:
            \(response1)
            
            """)
        // MARK: - MLX: Qwen2.5-1.5B-Instruct-4bit
        let `mlx_Qwen2.5-1.5B-Instruct-4bit` = try await LocalInferenceTestMLX(modelId: Model.`Qwen2.5-1.5B-Instruct-4bit`)
        let response2 = try await `mlx_Qwen2.5-1.5B-Instruct-4bit`.simple(prompt: Prompt.simple)
        print("""
            
            Qwen2.5-1.5B-Instruct-4bit:
            \(response2)
            
            """)
        // MARK: - MLX: Qwen2.5-3B-Instruct-4bit
        let `mlx_Qwen2.5-3B-Instruct-4bit` = try await LocalInferenceTestMLX(modelId: Model.`Qwen2.5-3B-Instruct-4bit`)
        let response3 = try await `mlx_Qwen2.5-3B-Instruct-4bit`.simple(prompt: Prompt.simple)
        print("""
            
            Qwen2.5-3B-Instruct-4bit:
            \(response3)
            
            """)
        
        
        
        // MARK: - MLX: Phi-2
        let `mlx_phi-2` = try await LocalInferenceTestMLX(modelId: Model.`phi-2`)
        let response4 = try await `mlx_phi-2`.simple(prompt: Prompt.simple)
        print("""
            
            Phi-2:
            \(response4)
            
            """)
    }
    
    
    
    @Test func startNER() async throws {
        
    }

}
