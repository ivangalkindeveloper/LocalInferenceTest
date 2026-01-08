import MLXLMCommon

final class MLXCache {
    static func cache(
        models: [String]
    ) async throws {
        for model in models {
            print("MLXCache start caching: \(model)")
            try await MLXLMCommon.loadModel(id: model)
            print("MLXCache caching success: \(model)")
        }
    }
}
