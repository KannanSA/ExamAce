import Foundation

struct RevisionItem: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var detail: String
    var durationMinutes: Int
    var weekday: Int
    var isCompleted: Bool
    var sortOrder: Int

    init(
        id: UUID = UUID(),
        title: String,
        detail: String,
        durationMinutes: Int,
        weekday: Int,
        isCompleted: Bool = false,
        sortOrder: Int = 0
    ) {
        self.id = id
        self.title = title
        self.detail = detail
        self.durationMinutes = durationMinutes
        self.weekday = weekday
        self.isCompleted = isCompleted
        self.sortOrder = sortOrder
    }
}

struct TutorProfile: Identifiable, Hashable {
    var id: UUID
    var name: String
    var subject: String
    var rate: String
    var rating: Double
    var bio: String
    var initials: String

    init(
        id: UUID = UUID(),
        name: String,
        subject: String,
        rate: String,
        rating: Double,
        bio: String
    ) {
        self.id = id
        self.name = name
        self.subject = subject
        self.rate = rate
        self.rating = rating
        self.bio = bio
        let parts = name.split(separator: " ")
        self.initials = parts.prefix(2).compactMap { $0.first }.map(String.init).joined()
    }
}

struct CompletedSession: Identifiable, Codable {
    var id: UUID
    var title: String
    var minutes: Int
    var finishedAt: Date
    var points: Int
}

enum ExamAceDefaults {
    static let pomodoroMinutes = 25
    static let moveGoalMinutes = 30
    static let pointsPerSession = 10
    static let defaultSessionTitle = "Further Maths Paper 2"
}
