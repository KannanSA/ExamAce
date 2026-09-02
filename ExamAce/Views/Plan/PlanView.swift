import SwiftUI

struct PlanView: View {
    @EnvironmentObject private var store: StudyStore
    @EnvironmentObject private var timer: StudyTimerService
    @EnvironmentObject private var calendar: CalendarService
    @State private var selectedWeekday: Int = Calendar.current.component(.weekday, from: Date())
    @State private var showingAdd = false
    @State private var toast: String?

    private let weekdays: [(Int, String)] = [
        (2, "Mon"), (3, "Tue"), (4, "Wed"), (5, "Thu"), (6, "Fri"), (7, "Sat"), (1, "Sun")
    ]

    private var dayItems: [RevisionItem] {
        store.items(for: selectedWeekday)
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    ExamAceTitle()
                        .frame(maxWidth: .infinity)
                    Text("Revision timetable")
                        .font(.system(.title3, design: .serif).weight(.medium))
                        .foregroundStyle(ExamAceTheme.inkFallback)

                    HStack(spacing: 8) {
                        ForEach(weekdays, id: \.0) { day in
                            Button {
                                selectedWeekday = day.0
                            } label: {
                                VStack(spacing: 6) {
                                    Text(day.1)
                                        .font(.caption.weight(.semibold))
                                    Circle()
                                        .fill(selectedWeekday == day.0 ? ExamAceTheme.goldFallback : Color.clear)
                                        .frame(width: 6, height: 6)
                                }
                                .foregroundStyle(
                                    selectedWeekday == day.0
                                        ? ExamAceTheme.inkFallback
                                        : ExamAceTheme.inkMuted
                                )
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(selectedWeekday == day.0 ? ExamAceTheme.card : Color.clear)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    if dayItems.isEmpty {
                        PaperCard {
                            Text("No sessions on this day yet.")
                                .foregroundStyle(ExamAceTheme.inkMuted)
                        }
                    } else {
                        ForEach(dayItems) { item in
                            PaperCard {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.title)
                                            .font(.system(.headline, design: .serif))
                                        Text("\(item.detail) · \(item.durationMinutes) min")
                                            .font(.caption)
                                            .foregroundStyle(ExamAceTheme.inkMuted)
                                    }
                                    Spacer()
                                    Button("Start") {
                                        timer.load(item: item)
                                        timer.start()
                                    }
                                    .font(.caption.weight(.semibold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Capsule().fill(ExamAceTheme.inkFallback))
                                    .foregroundStyle(ExamAceTheme.paperFallback)
                                }
                            }
                        }
                    }

                    HStack {
                        Button("Add session") { showingAdd = true }
                        Spacer()
                        Button("Export day") {
                            calendar.exportToday(dayItems)
                            toast = calendar.lastExportMessage
                        }
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(ExamAceTheme.rust)

                    if let toast {
                        Text(toast)
                            .font(.caption)
                            .foregroundStyle(ExamAceTheme.inkMuted)
                    }
                }
                .padding(20)
            }
            .examAceScreen()
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAdd) {
                AddRevisionSheet(weekday: selectedWeekday)
            }
        }
    }
}

private struct AddRevisionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: StudyStore
    var weekday: Int
    @State private var title = ExamAceDefaults.defaultSessionTitle
    @State private var detail = ""
    @State private var minutes = ExamAceDefaults.pomodoroMinutes

    var body: some View {
        NavigationStack {
            Form {
                TextField("Subject", text: $title)
                TextField("Focus", text: $detail)
                Stepper("\(minutes) minutes", value: $minutes, in: 10...90, step: 5)
            }
            .scrollContentBackground(.hidden)
            .background(ExamAceTheme.paperFallback)
            .navigationTitle("New session")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        store.addItem(title: title, detail: detail, minutes: minutes, weekday: weekday)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

#Preview {
    PlanView()
        .environmentObject(StudyStore())
        .environmentObject(StudyTimerService())
        .environmentObject(CalendarService())
}
