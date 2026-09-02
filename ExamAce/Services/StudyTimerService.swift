import Combine
import Foundation
import UIKit

/// Local 25-minute study timer. Remaining time is anchored to an end date so
/// backgrounding the app does not freeze the countdown while it is running.
@MainActor
final class StudyTimerService: ObservableObject {
    static let defaultDuration: TimeInterval = TimeInterval(ExamAceDefaults.pomodoroMinutes * 60)

    @Published private(set) var remaining: TimeInterval
    @Published private(set) var duration: TimeInterval
    @Published private(set) var isRunning: Bool
    @Published var sessionTitle: String
    @Published var linkedItemID: UUID?
    @Published var didCompleteSession: Bool = false

    private var endDate: Date?
    private var ticker: AnyCancellable?
    private let defaults: UserDefaults

    private enum Key {
        static let remaining = "examace.timer.remaining"
        static let duration = "examace.timer.duration"
        static let running = "examace.timer.running"
        static let endDate = "examace.timer.endDate"
        static let title = "examace.timer.title"
        static let item = "examace.timer.item"
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.remaining = Self.defaultDuration
        self.duration = Self.defaultDuration
        self.isRunning = false
        self.sessionTitle = ExamAceDefaults.defaultSessionTitle
    }

    var progress: Double {
        guard duration > 0 else { return 0 }
        return min(1, max(0, remaining / duration))
    }

    var sessionMinutes: Int {
        max(1, Int(duration / 60))
    }

    var timeText: String {
        let total = max(0, Int(remaining.rounded(.up)))
        let minutes = total / 60
        let seconds = total % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    var controlTitle: String {
        if remaining <= 0 { return "Reset" }
        if isRunning { return "Pause" }
        if remaining < duration { return "Resume" }
        return "Start"
    }

    func restore() {
        sessionTitle = defaults.string(forKey: Key.title) ?? ExamAceDefaults.defaultSessionTitle
        if let item = defaults.string(forKey: Key.item) {
            linkedItemID = UUID(uuidString: item)
        }
        let storedRemaining = defaults.object(forKey: Key.remaining) as? Double
        remaining = storedRemaining ?? Self.defaultDuration
        duration = max(remaining, defaults.object(forKey: Key.duration) as? Double ?? Self.defaultDuration)
        isRunning = defaults.bool(forKey: Key.running)
        endDate = defaults.object(forKey: Key.endDate) as? Date
        syncFromClock()
        if isRunning {
            startTicker()
        }
    }

    func load(item: RevisionItem) {
        pause()
        sessionTitle = item.title
        linkedItemID = item.id
        duration = TimeInterval(max(1, item.durationMinutes) * 60)
        remaining = duration
        persist()
    }

    func toggle() {
        if remaining <= 0 {
            reset()
            return
        }
        if isRunning {
            pause()
        } else {
            start()
        }
    }

    func start() {
        guard remaining > 0 else { return }
        isRunning = true
        endDate = Date().addingTimeInterval(remaining)
        persist()
        startTicker()
    }

    func pause() {
        syncFromClock()
        isRunning = false
        endDate = nil
        ticker?.cancel()
        ticker = nil
        persist()
    }

    func reset() {
        ticker?.cancel()
        ticker = nil
        isRunning = false
        endDate = nil
        remaining = duration
        didCompleteSession = false
        persist()
    }

    func syncFromClock() {
        guard isRunning, let endDate else { return }
        remaining = max(0, endDate.timeIntervalSinceNow)
        if remaining <= 0 {
            finish()
        }
    }

    private func startTicker() {
        ticker?.cancel()
        ticker = Timer.publish(every: 0.2, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.syncFromClock()
            }
    }

    private func finish() {
        remaining = 0
        isRunning = false
        endDate = nil
        ticker?.cancel()
        ticker = nil
        didCompleteSession = true
        persist()
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    func acknowledgeCompletion() {
        didCompleteSession = false
        remaining = duration
        persist()
    }

    private func persist() {
        defaults.set(remaining, forKey: Key.remaining)
        defaults.set(duration, forKey: Key.duration)
        defaults.set(isRunning, forKey: Key.running)
        defaults.set(sessionTitle, forKey: Key.title)
        if let endDate {
            defaults.set(endDate, forKey: Key.endDate)
        } else {
            defaults.removeObject(forKey: Key.endDate)
        }
        if let linkedItemID {
            defaults.set(linkedItemID.uuidString, forKey: Key.item)
        }
    }
}
