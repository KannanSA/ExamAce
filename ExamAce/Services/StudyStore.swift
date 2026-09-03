import Combine
import Foundation

@MainActor
final class StudyStore: ObservableObject {
    @Published var items: [RevisionItem] = []
    @Published var sessions: [CompletedSession] = []
    @Published var points: Int = 0
    @Published var streak: Int = 0
    @Published var lastStudyDay: Date?

    private let defaults: UserDefaults
    private let calendar: Calendar

    private enum Key {
        static let items = "examace.store.items"
        static let sessions = "examace.store.sessions"
        static let points = "examace.store.points"
        static let streak = "examace.store.streak"
        static let lastDay = "examace.store.lastDay"
    }

    init(defaults: UserDefaults = .standard, calendar: Calendar = .current) {
        self.defaults = defaults
        self.calendar = calendar
        load()
    }

    var todayWeekday: Int {
        calendar.component(.weekday, from: Date())
    }

    var todaysRevision: [RevisionItem] {
        items
            .filter { $0.weekday == todayWeekday }
            .sorted { $0.sortOrder < $1.sortOrder }
    }

    func items(for weekday: Int) -> [RevisionItem] {
        items.filter { $0.weekday == weekday }.sorted { $0.sortOrder < $1.sortOrder }
    }

    func bootstrapIfNeeded() {
        if items.isEmpty {
            items = Self.samplePlan()
            save()
        }
        refreshStreakIfMissed()
    }

    func toggleCompleted(_ item: RevisionItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].isCompleted.toggle()
        save()
    }

    func addItem(title: String, detail: String, minutes: Int, weekday: Int) {
        let order = (items(for: weekday).map(\.sortOrder).max() ?? -1) + 1
        items.append(
            RevisionItem(
                title: title,
                detail: detail,
                durationMinutes: minutes,
                weekday: weekday,
                sortOrder: order
            )
        )
        save()
    }

    func recordCompletion(title: String, minutes: Int, itemID: UUID?) {
        let session = CompletedSession(
            id: UUID(),
            title: title,
            minutes: minutes,
            finishedAt: Date(),
            points: ExamAceDefaults.pointsPerSession
        )
        sessions.insert(session, at: 0)
        points += ExamAceDefaults.pointsPerSession
        if let itemID, let index = items.firstIndex(where: { $0.id == itemID }) {
            items[index].isCompleted = true
        } else if let index = items.firstIndex(where: { $0.title == title && $0.weekday == todayWeekday }) {
            items[index].isCompleted = true
        }
        updateStreakForToday()
        save()
    }

    private func updateStreakForToday() {
        let today = calendar.startOfDay(for: Date())
        if let last = lastStudyDay.map({ calendar.startOfDay(for: $0) }) {
            if last == today {
                if streak == 0 { streak = 1 }
                return
            }
            let yesterday = calendar.date(byAdding: .day, value: -1, to: today)
            if last == yesterday {
                streak += 1
            } else {
                streak = 1
            }
        } else {
            streak = 1
        }
        lastStudyDay = today
    }

    private func refreshStreakIfMissed() {
        guard let last = lastStudyDay.map({ calendar.startOfDay(for: $0) }) else { return }
        let today = calendar.startOfDay(for: Date())
        if last == today { return }
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)
        if last != yesterday {
            streak = 0
            save()
        }
    }

    private func load() {
        if let data = defaults.data(forKey: Key.items),
           let decoded = try? JSONDecoder().decode([RevisionItem].self, from: data) {
            items = decoded
        }
        if let data = defaults.data(forKey: Key.sessions),
           let decoded = try? JSONDecoder().decode([CompletedSession].self, from: data) {
            sessions = decoded
        }
        points = defaults.integer(forKey: Key.points)
        streak = defaults.integer(forKey: Key.streak)
        lastStudyDay = defaults.object(forKey: Key.lastDay) as? Date
    }

    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            defaults.set(data, forKey: Key.items)
        }
        if let data = try? JSONEncoder().encode(sessions) {
            defaults.set(data, forKey: Key.sessions)
        }
        defaults.set(points, forKey: Key.points)
        defaults.set(streak, forKey: Key.streak)
        defaults.set(lastStudyDay, forKey: Key.lastDay)
    }

    static func samplePlan() -> [RevisionItem] {
        let maths = ExamAceDefaults.defaultSessionTitle
        func sessions(_ weekday: Int, _ rows: [(String, String, Int)]) -> [RevisionItem] {
            rows.enumerated().map { index, row in
                RevisionItem(
                    title: row.0,
                    detail: row.1,
                    durationMinutes: row.2,
                    weekday: weekday,
                    sortOrder: index
                )
            }
        }
        return sessions(2, [
            (maths, "Vectors & matrices", 25),
            ("Physics", "Waves past paper", 25),
            ("Chemistry", "Organic mechanisms", 20)
        ]) + sessions(3, [
            (maths, "Complex numbers", 25),
            ("English Lit", "Unseen poetry", 25),
            ("Biology", "Cell division", 20)
        ]) + sessions(4, [
            (maths, "Proof by induction", 25),
            ("Physics", "Fields recap", 25),
            ("Chemistry", "Energetics", 20)
        ]) + sessions(5, [
            (maths, "Differential equations", 25),
            ("Chemistry", "Energetics", 25),
            ("History", "Essay plan", 20)
        ]) + sessions(6, [
            (maths, "Paper 2 mixed drill", 25),
            ("Physics", "Practical write-up", 25),
            ("English Lit", "Quote bank", 20)
        ]) + sessions(7, [
            (maths, "Light review", 25),
            ("Biology", "Flashcards", 20)
        ]) + sessions(1, [
            (maths, "Gentle recap", 25)
        ])
    }

    static let sampleTutors: [TutorProfile] = [
        TutorProfile(
            name: "Amara Cole",
            subject: "Further Maths",
            rate: "£34 / hr",
            rating: 4.9,
            bio: "Ex-examiner. Paper 2 vectors, matrices and proof."
        ),
        TutorProfile(
            name: "Jonah Reid",
            subject: "Physics",
            rate: "£30 / hr",
            rating: 4.8,
            bio: "Calm walkthroughs of waves, fields and practicals."
        ),
        TutorProfile(
            name: "Priya Shah",
            subject: "Chemistry",
            rate: "£32 / hr",
            rating: 4.7,
            bio: "Organic mechanisms with mark-scheme language."
        )
    ]
}
