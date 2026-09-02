import SwiftUI

@main
struct ExamAceApp: App {
    @StateObject private var store = StudyStore()
    @StateObject private var timer = StudyTimerService()
    @StateObject private var health = HealthKitService()
    @StateObject private var auth = AppleAuthService()
    @StateObject private var calendar = CalendarService()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(store)
                .environmentObject(timer)
                .environmentObject(health)
                .environmentObject(auth)
                .environmentObject(calendar)
                .preferredColorScheme(.light)
                .onAppear {
                    store.bootstrapIfNeeded()
                    timer.restore()
                    health.loadSampleOrLiveData()
                }
        }
    }
}
