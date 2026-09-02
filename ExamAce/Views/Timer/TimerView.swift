import SwiftUI

struct TimerView: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var store: StudyStore
    @EnvironmentObject private var timer: StudyTimerService
    @EnvironmentObject private var health: HealthKitService

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {
                    ExamAceTitle()
                        .padding(.top, 8)

                    CircularTimerRing(
                        progress: timer.progress,
                        timeText: timer.timeText,
                        sessionTitle: timer.sessionTitle
                    )
                    .padding(.horizontal, 28)
                    .padding(.top, 4)

                    PausePill(title: timer.controlTitle, isRunning: timer.isRunning) {
                        timer.toggle()
                    }

                    if timer.remaining < timer.duration && timer.remaining > 0 {
                        Button("Reset") { timer.reset() }
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(ExamAceTheme.inkMuted)
                    }

                    HStack(spacing: 12) {
                        StatCard(
                            title: "Sleep",
                            value: health.sleepText,
                            symbol: "moon.fill"
                        )
                        StatCard(
                            title: "Move",
                            value: health.moveText,
                            symbol: "figure.walk"
                        )
                        StatCard(
                            title: "Streak",
                            value: streakText,
                            symbol: "flame.fill"
                        )
                    }

                    TodaysRevisionList()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 28)
            }
            .examAceScreen()
            .navigationBarHidden(true)
            .onChange(of: scenePhase) { _, phase in
                if phase == .active {
                    timer.syncFromClock()
                }
            }
            .onChange(of: timer.didCompleteSession) { _, completed in
                if completed {
                    let minutes = timer.sessionMinutes
                    store.recordCompletion(
                        title: timer.sessionTitle,
                        minutes: minutes,
                        itemID: timer.linkedItemID
                    )
                }
            }
            .alert("Session complete", isPresented: completionBinding) {
                Button("Start next") {
                    timer.acknowledgeCompletion()
                }
            } message: {
                Text("+\(ExamAceDefaults.pointsPerSession) points. Keep the streak going.")
            }
        }
    }

    private var streakText: String {
        store.streak == 1 ? "1 day" : "\(store.streak) days"
    }

    private var completionBinding: Binding<Bool> {
        Binding(
            get: { timer.didCompleteSession },
            set: { value in
                if !value {
                    timer.acknowledgeCompletion()
                }
            }
        )
    }
}

struct CircularTimerRing: View {
    var progress: Double
    var timeText: String
    var sessionTitle: String

    var body: some View {
        ZStack {
            Circle()
                .stroke(ExamAceTheme.goldFallback.opacity(0.18), lineWidth: 16)
            Circle()
                .trim(from: 0, to: max(0.001, min(1, progress)))
                .stroke(
                    AngularGradient(
                        colors: [
                            ExamAceTheme.goldBright,
                            ExamAceTheme.goldFallback,
                            ExamAceTheme.rust,
                            ExamAceTheme.goldBright
                        ],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 16, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: ExamAceTheme.goldFallback.opacity(0.35), radius: 8)
                .animation(.easeInOut(duration: 0.2), value: progress)

            VStack(spacing: 10) {
                Text(timeText)
                    .font(.system(size: 58, weight: .medium, design: .serif))
                    .monospacedDigit()
                    .foregroundStyle(ExamAceTheme.inkFallback)
                Text(sessionTitle)
                    .font(.system(.subheadline, design: .serif))
                    .foregroundStyle(ExamAceTheme.inkMuted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(sessionTitle), \(timeText) remaining")
    }
}

struct PausePill: View {
    var title: String
    var isRunning: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: isRunning ? "pause.fill" : "play.fill")
                Text(title)
                    .font(.system(.body, design: .rounded).weight(.semibold))
            }
            .foregroundStyle(ExamAceTheme.paperFallback)
            .padding(.horizontal, 32)
            .padding(.vertical, 13)
            .background(
                Capsule()
                    .fill(ExamAceTheme.inkFallback)
                    .shadow(color: ExamAceTheme.inkFallback.opacity(0.2), radius: 8, y: 3)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }
}

struct StatCard: View {
    var title: String
    var value: String
    var symbol: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: symbol)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(ExamAceTheme.goldFallback)
                .frame(width: 28, height: 28)
                .background(Circle().fill(ExamAceTheme.goldFallback.opacity(0.15)))
            Text(title)
                .font(.caption)
                .foregroundStyle(ExamAceTheme.inkMuted)
            Text(value)
                .font(.system(.headline, design: .serif))
                .foregroundStyle(ExamAceTheme.inkFallback)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(ExamAceTheme.card)
                .shadow(color: ExamAceTheme.inkFallback.opacity(0.07), radius: 8, y: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(ExamAceTheme.goldFallback.opacity(0.16), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
    }
}

struct TodaysRevisionList: View {
    @EnvironmentObject private var store: StudyStore
    @EnvironmentObject private var timer: StudyTimerService

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today’s revision")
                .font(.system(.title3, design: .serif).weight(.medium))
                .foregroundStyle(ExamAceTheme.inkFallback)

            if store.todaysRevision.isEmpty {
                Text("Nothing planned today. Add a session in Plan.")
                    .font(.subheadline)
                    .foregroundStyle(ExamAceTheme.inkMuted)
                    .padding(.vertical, 8)
            } else {
                ForEach(store.todaysRevision) { item in
                    Button {
                        timer.load(item: item)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(item.isCompleted ? ExamAceTheme.goldFallback : ExamAceTheme.inkMuted)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.title)
                                    .font(.system(.body, design: .serif).weight(.medium))
                                    .foregroundStyle(ExamAceTheme.inkFallback)
                                    .strikethrough(item.isCompleted)
                                Text(item.detail)
                                    .font(.caption)
                                    .foregroundStyle(ExamAceTheme.inkMuted)
                            }
                            Spacer()
                            Text("\(item.durationMinutes)m")
                                .font(.caption.monospacedDigit())
                                .foregroundStyle(ExamAceTheme.inkMuted)
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(ExamAceTheme.card)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(
                                    timer.linkedItemID == item.id
                                        ? ExamAceTheme.goldFallback.opacity(0.7)
                                        : ExamAceTheme.goldFallback.opacity(0.12),
                                    lineWidth: 1
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
    }
}

#Preview {
    TimerView()
        .environmentObject(StudyStore())
        .environmentObject(StudyTimerService())
        .environmentObject(HealthKitService())
}
