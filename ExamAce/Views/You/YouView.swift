import SwiftUI

struct YouView: View {
    @EnvironmentObject private var store: StudyStore
    @EnvironmentObject private var auth: AppleAuthService
    @EnvironmentObject private var health: HealthKitService
    @State private var showPrivacy = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    ExamAceTitle()
                        .frame(maxWidth: .infinity)
                    Text("You")
                        .font(.system(.title3, design: .serif).weight(.medium))
                        .foregroundStyle(ExamAceTheme.inkFallback)

                    PaperCard {
                        HStack(spacing: 14) {
                            Circle()
                                .fill(ExamAceTheme.inkFallback)
                                .frame(width: 56, height: 56)
                                .overlay(
                                    Text(String(auth.displayName.prefix(1)))
                                        .font(.system(.title2, design: .serif))
                                        .foregroundStyle(ExamAceTheme.paperFallback)
                                )
                            VStack(alignment: .leading, spacing: 4) {
                                Text(auth.displayName)
                                    .font(.system(.headline, design: .serif))
                                Text(auth.isSignedIn ? "Signed in on this device" : "Guest · local study data")
                                    .font(.caption)
                                    .foregroundStyle(ExamAceTheme.inkMuted)
                            }
                        }
                    }

                    HStack(spacing: 12) {
                        StatCard(title: "Points", value: "\(store.points)", symbol: "star.fill")
                        StatCard(
                            title: "Streak",
                            value: store.streak == 1 ? "1 day" : "\(store.streak) days",
                            symbol: "flame.fill"
                        )
                        StatCard(title: "Sessions", value: "\(store.sessions.count)", symbol: "checkmark.circle")
                    }

                    PaperCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Sign in with Apple")
                                .font(.headline)
                            Text(auth.statusMessage)
                                .font(.caption)
                                .foregroundStyle(ExamAceTheme.inkMuted)
                            Button(auth.isSignedIn ? "Sign out" : "Continue with Apple") {
                                if auth.isSignedIn {
                                    auth.signOut()
                                } else {
                                    auth.signIn()
                                }
                            }
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(ExamAceTheme.rust)
                        }
                    }

                    PaperCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Apple Health")
                                .font(.headline)
                            Text(health.statusMessage)
                                .font(.caption)
                                .foregroundStyle(ExamAceTheme.inkMuted)
                            Button("Request HealthKit access") {
                                health.requestAccess()
                            }
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(ExamAceTheme.rust)
                        }
                    }

                    if !store.sessions.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Recent sessions")
                                .font(.system(.headline, design: .serif))
                            ForEach(store.sessions.prefix(5)) { session in
                                HStack {
                                    Text(session.title)
                                    Spacer()
                                    Text("+\(session.points)")
                                        .foregroundStyle(ExamAceTheme.goldFallback)
                                }
                                .font(.subheadline)
                            }
                        }
                    }

                    Button("Privacy policy") { showPrivacy = true }
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(ExamAceTheme.inkMuted)
                        .padding(.top, 4)
                }
                .padding(20)
            }
            .examAceScreen()
            .navigationBarHidden(true)
            .sheet(isPresented: $showPrivacy) {
                NavigationStack {
                    ScrollView {
                        Text(Self.privacySummary)
                            .font(.body)
                            .padding()
                    }
                    .background(ExamAceTheme.paperFallback)
                    .navigationTitle("Privacy")
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") { showPrivacy = false }
                        }
                    }
                }
            }
        }
    }

    private static let privacySummary = """
    ExamAce stores study sessions, streaks and points on this device. HealthKit and Sign in with Apple are optional and currently stubbed until those capabilities are enabled in Xcode.

    We read sleep and exercise data only with your permission, and never write to Health. Tutor profiles are intended to sync with CloudKit in a later build.

    Full policy: see README.md in the ExamAce repository, or email privacy@examace.app.
    """
}

#Preview {
    YouView()
        .environmentObject(StudyStore())
        .environmentObject(AppleAuthService())
        .environmentObject(HealthKitService())
}
