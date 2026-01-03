import Darwin.Mach
import XCTest

enum Performer {
    static func run<T>(
        _ modelId: String,
        _ type: String,
        _ execute: () async throws -> T,
        _ printable: (T) -> String,
    ) async throws -> T {
        let cpu0 = currentCPUTimeMs()
        let mem0 = currentMemoryMB()
        let clock = ContinuousClock()
        let start = clock.now
        
        let response = try await execute()
        
        let duration = start.duration(to: clock.now)
        let wallMs = (Double(duration.components.seconds) * 1000) + Double(duration.components.attoseconds) / 1e15
        let cpuMs = currentCPUTimeMs() - cpu0
        let mem1 = currentMemoryMB()
        let memDiff = (mem0 >= 0 && mem1 >= 0) ? mem1 - mem0 : nil
        
        print("""
            
            ====== \(modelId) - \(type) ======
            ====== Wall: \(String(format: "%.1f", wallMs)) ms
            ====== CPU:  \(String(format: "%.1f", cpuMs)) ms
            ====== RSS:  \(mem1 >= 0 ? String(format: "%.1f", mem1) : "n/a") MB\(memDiff != nil ? " (Δ \(String(format: "%.1f", memDiff!)) MB)" : "")
            ====== Response:
                \(printable(response))
            ======
                
                
            """
        )
        
        return response
    }
    
    private static func currentCPUTimeMs() -> Double {
        var threads: thread_act_array_t?
        var count = mach_msg_type_number_t(0)
        guard task_threads(mach_task_self_, &threads, &count) == KERN_SUCCESS, let threads else { return 0 }
        defer { vm_deallocate(mach_task_self_, vm_address_t(UInt(bitPattern: threads)), vm_size_t(Int(count) * MemoryLayout<thread_t>.stride)) }

        var total: Double = 0
        for i in 0 ..< Int(count) {
            var info = thread_basic_info()
            var infoCount = mach_msg_type_number_t(THREAD_INFO_MAX)
            if thread_info(threads[i],
                           thread_flavor_t(THREAD_BASIC_INFO),
                           withUnsafeMutablePointer(to: &info) {
                               $0.withMemoryRebound(to: integer_t.self, capacity: Int(infoCount)) { $0 }
                           },
                           &infoCount) == KERN_SUCCESS,
                info.flags & TH_FLAGS_IDLE == 0
            {
                let user = Double(info.user_time.seconds) * 1000 + Double(info.user_time.microseconds) / 1000
                let sys = Double(info.system_time.seconds) * 1000 + Double(info.system_time.microseconds) / 1000
                total += user + sys
            }
        }
        return total
    }
    
    private static func currentMemoryMB() -> Double {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout.size(ofValue: info) / MemoryLayout<natural_t>.size)
        let kerr = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        guard kerr == KERN_SUCCESS else { return -1 }
        return Double(info.resident_size) / 1048576 // MB
    }
}
