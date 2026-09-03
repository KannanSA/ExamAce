import SwiftUI
import UIKit

struct RootTabView: View {
    @State private var tab: AppTab = .timer

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(ExamAceTheme.paperFallback)
        let item = appearance.stackedLayoutAppearance
        item.normal.iconColor = UIColor(ExamAceTheme.inkMuted)
        item.normal.titleTextAttributes = [.foregroundColor: UIColor(ExamAceTheme.inkMuted)]
        item.selected.iconColor = UIColor(ExamAceTheme.goldFallback)
        item.selected.titleTextAttributes = [.foregroundColor: UIColor(ExamAceTheme.rust)]
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView(selection: $tab) {
            PlanView()
                .tabItem { Label("Plan", systemImage: "calendar") }
                .tag(AppTab.plan)
            TimerView()
                .tabItem { Label("Timer", systemImage: "timer") }
                .tag(AppTab.timer)
            TutorsView()
                .tabItem { Label("Tutors", systemImage: "person.2.fill") }
                .tag(AppTab.tutors)
            SleepView()
                .tabItem { Label("Sleep", systemImage: "moon.zzz.fill") }
                .tag(AppTab.sleep)
            YouView()
                .tabItem { Label("You", systemImage: "person.crop.circle") }
                .tag(AppTab.you)
        }
        .tint(ExamAceTheme.rust)
    }
}

enum AppTab: Hashable {
    case plan, timer, tutors, sleep, you
}

#Preview {
    RootTabView()
        .environmentObject(StudyStore())
        .environmentObject(StudyTimerService())
        .environmentObject(HealthKitService())
        .environmentObject(AppleAuthService())
        .environmentObject(CalendarService())
}
