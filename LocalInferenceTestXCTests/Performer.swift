import MachO
import os
import Darwin.Mach
import XCTest

final class Performer: XCTestCase {
    func run <T>(
        _ modelId: String,
        _ type: String,
        _ execute: @escaping () async throws -> T,
        _ printable: (T) -> String,
    ) async throws -> T {
        let metrics: [XCTMetric] = [
            XCTCPUMetric(),
            XCTClockMetric(),
            XCTMemoryMetric(),
            XCTOSSignpostMetric(
                subsystem: "com.ivangalkindev.LocalInferenceTest",
                category: "LocalInference",
                name: "LocalInference"
            )
        ]
        
        var response: T?
        measure(metrics: metrics) {
            Task {
                response = try await execute()
            }
        }

        print("""


            ====== \(modelId) - \(type) ======
            ====== Response:
                \(printable(response!))
            ======


            """
        )

        return response!
    }
    
//    func run <T>(
//        _ modelId: String,
//        _ type: String,
//        _ execute: () async throws -> T,
//        _ printable: (T) -> String,
//    ) async throws -> T {
//        let cpuBefore = currentCPUUsage()
//        let memoryBefore = currentMemoryUsage()
//        let clock = ContinuousClock()
//        let clockStart = clock.now
//        
//        let response = try await execute()
//        
//        let cpuDelta = currentCPUUsage() - cpuBefore
//        let memoryDelta = currentMemoryUsage() - memoryBefore
//        let clockElapsed = clockStart.duration(to: clock.now)
//        
//        print("""
//            
//            
//            ====== \(modelId) - \(type) ======
//            ====== CPU: \(cpuDelta) ======
//            ====== Memory: \(memoryDelta) ======
//            ====== Elapsed: \(clockElapsed) ======
//            ====== Response:
//                \(printable(response))
//            ======
//            
//            
//            """
//        )
//        
//        return response
//    }
//    
//    private static func currentMemoryUsage() -> UInt64 {
//        var info = mach_task_basic_info()
//        var count = mach_msg_type_number_t(MemoryLayout.size(ofValue: info)) / 4
//
//        let kerr = withUnsafeMutablePointer(to: &info) {
//            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
//                task_info(mach_task_self_,
//                          task_flavor_t(MACH_TASK_BASIC_INFO),
//                          $0,
//                          &count)
//            }
//        }
//
//        guard kerr == KERN_SUCCESS else { return 0 }
//        return UInt64(info.resident_size) // bytes in RAM
//    }
//    
//    private static func currentCPUUsage() -> Double {
//        var threadsList: thread_act_array_t?
//        var threadCount = mach_msg_type_number_t(0)
//
//        guard task_threads(mach_task_self_, &threadsList, &threadCount) == KERN_SUCCESS,
//              let threads = threadsList else {
//            return 0
//        }
//
//        var totalUsage: Double = 0
//
//        for i in 0..<Int(threadCount) {
//            var info = thread_basic_info()
//            var infoCount = mach_msg_type_number_t(THREAD_INFO_MAX)
//
//            if thread_info(threads[i],
//                           thread_flavor_t(THREAD_BASIC_INFO),
//                           withUnsafeMutablePointer(to: &info) {
//                               $0.withMemoryRebound(to: integer_t.self, capacity: Int(infoCount)) { $0 }
//                           },
//                           &infoCount) == KERN_SUCCESS {
//
//                if info.flags & TH_FLAGS_IDLE == 0 {
//                    totalUsage += Double(info.cpu_usage) / Double(TH_USAGE_SCALE) * 100.0
//                }
//            }
//        }
//
//        return totalUsage
//    }
    
}
