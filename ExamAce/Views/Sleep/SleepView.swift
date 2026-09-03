import SwiftUI

struct SleepView: View {
    @EnvironmentObject private var health: HealthKitService
    @State private var breathing = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    ExamAceTitle()
                        .frame(maxWidth: .infinity)
                    Text("Rest & recover")
                        .font(.system(.title3, design: .serif).weight(.medium))
                        .foregroundStyle(ExamAceTheme.inkFallback)

                    HStack(spacing: 12) {
                        StatCard(title: "Last night", value: health.sleepText, symbol: "moon.fill")
                        StatCard(title: "Move", value: health.moveText, symbol: "figure.walk")
                    }

                    PaperCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("HealthKit")
                                .font(.headline)
                            Text(health.statusMessage)
                                .font(.caption)
                                .foregroundStyle(ExamAceTheme.inkMuted)
                            Button("Connect Apple Health") {
                                health.requestAccess()
                            }
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(ExamAceTheme.rust)
                        }
                    }

                    PaperCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("2-minute breathing")
                                .font(.system(.headline, design: .serif))
                            Text("In for 4, hold 4, out 4, hold 4. A short reset between papers.")
                                .font(.caption)
                                .foregroundStyle(ExamAceTheme.inkMuted)
                            BreathingFlower(isActive: breathing)
                                .frame(height: 180)
                                .frame(maxWidth: .infinity)
                            Button(breathing ? "Stop" : "Begin") {
                                breathing.toggle()
                            }
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Capsule().fill(ExamAceTheme.inkFallback))
                            .foregroundStyle(ExamAceTheme.paperFallback)
                        }
                    }
                }
                .padding(20)
            }
            .examAceScreen()
            .navigationBarHidden(true)
        }
    }
}

private struct BreathingFlower: View {
    var isActive: Bool
    @State private var scale: CGFloat = 0.72
    @State private var label = "Breathe in"
    @State private var loop: Task<Void, Never>?

    var body: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [ExamAceTheme.goldBright.opacity(0.9), ExamAceTheme.goldFallback.opacity(0.25)],
                        center: .center,
                        startRadius: 10,
                        endRadius: 90
                    )
                )
                .frame(width: 120, height: 120)
                .scaleEffect(scale)
            Text(label)
                .font(.system(.subheadline, design: .serif))
                .foregroundStyle(ExamAceTheme.inkMuted)
        }
        .onChange(of: isActive) { _, active in
            loop?.cancel()
            loop = nil
            if active {
                loop = Task { await runLoop() }
            } else {
                withAnimation(.easeInOut(duration: 0.4)) {
                    scale = 0.72
                    label = "Breathe in"
                }
            }
        }
        .onDisappear {
            loop?.cancel()
        }
    }

    @MainActor
    private func runLoop() async {
        while !Task.isCancelled {
            if Task.isCancelled { return }
            await phase("Breathe in", scale: 1.08)
            await phase("Hold", scale: 1.08)
            await phase("Breathe out", scale: 0.72)
            await phase("Hold", scale: 0.72)
        }
    }

    @MainActor
    private func phase(_ text: String, scale newScale: CGFloat) async {
        guard !Task.isCancelled else { return }
        label = text
        withAnimation(.easeInOut(duration: 4)) {
            scale = newScale
        }
        do {
            try await Task.sleep(for: .seconds(4))
        } catch {
            return
        }
    }
}

#Preview {
    SleepView()
        .environmentObject(HealthKitService())
}
