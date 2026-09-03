import Combine
import Foundation

/// EventKit calendar export is stubbed until Calendar access is granted.
///
/// TODO: Request EventKit access and create EKEvent entries for revision items.
@MainActor
final class CalendarService: ObservableObject {
    @Published var lastExportMessage: String = "Calendar export is not connected yet"

    func export(_ item: RevisionItem) {
        // TODO: Use EventKit to insert a timed study block on the item's weekday.
        lastExportMessage = "Would add “\(item.title)” (\(item.durationMinutes) min) to Calendar."
    }

    func exportToday(_ items: [RevisionItem]) {
        lastExportMessage = "Would export \(items.count) session(s) to Calendar."
    }
}
