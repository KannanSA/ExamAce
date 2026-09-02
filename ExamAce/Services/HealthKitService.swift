import Combine
import Foundation

/// HealthKit is stubbed until the HealthKit capability is added in Xcode.
///
/// TODO: Enable HealthKit in Signing & Capabilities, then replace
/// `loadSampleOrLiveData()` with `HKHealthStore` queries for:
///   - `HKCategoryType(.sleepAnalysis)` last night
///   - `HKQuantityType(.appleExerciseTime)` today
@MainActor
final class HealthKitService: ObservableObject {
    @Published var sleepSeconds: TimeInterval = (7 * 3600) + (12 * 60)
    @Published var exerciseMinutes: Int = 18
    @Published var isLive: Bool = false
    @Published var statusMessage: String = "Showing sample sleep and move data"

    var sleepText: String {
        let hours = Int(sleepSeconds) / 3600
        let minutes = (Int(sleepSeconds) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }

    var moveText: String {
        "\(exerciseMinutes) / \(ExamAceDefaults.moveGoalMinutes) min"
    }

    var moveProgress: Double {
        min(1, Double(exerciseMinutes) / Double(ExamAceDefaults.moveGoalMinutes))
    }

    func loadSampleOrLiveData() {
        // TODO: Request HKHealthStore authorization and read live values.
        isLive = false
        statusMessage = "HealthKit capability not enabled — using sample data"
    }

    func requestAccess() {
        // TODO: HKHealthStore().requestAuthorization(toShare: [], read: [sleep, exercise])
        statusMessage = "Connect HealthKit in Xcode Signing & Capabilities, then rebuild."
    }
}
