import SwiftUI

struct TutorsView: View {
    @State private var booked: Set<UUID> = []
    @State private var message: String?

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    ExamAceTitle()
                        .frame(maxWidth: .infinity)
                    Text("Find a tutor")
                        .font(.system(.title3, design: .serif).weight(.medium))
                        .foregroundStyle(ExamAceTheme.inkFallback)
                    Text("Bookings stay on this device until CloudKit is connected.")
                        .font(.caption)
                        .foregroundStyle(ExamAceTheme.inkMuted)

                    ForEach(StudyStore.sampleTutors) { tutor in
                        PaperCard {
                            HStack(alignment: .top, spacing: 14) {
                                Text(tutor.initials)
                                    .font(.system(.headline, design: .serif))
                                    .foregroundStyle(ExamAceTheme.paperFallback)
                                    .frame(width: 48, height: 48)
                                    .background(Circle().fill(ExamAceTheme.inkFallback))
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text(tutor.name)
                                            .font(.system(.headline, design: .serif))
                                        Spacer()
                                        Text(String(format: "%.1f", tutor.rating))
                                            .font(.caption.weight(.semibold))
                                        Image(systemName: "star.fill")
                                            .font(.caption2)
                                            .foregroundStyle(ExamAceTheme.goldFallback)
                                    }
                                    Text("\(tutor.subject) · \(tutor.rate)")
                                        .font(.caption)
                                        .foregroundStyle(ExamAceTheme.inkMuted)
                                    Text(tutor.bio)
                                        .font(.subheadline)
                                        .foregroundStyle(ExamAceTheme.inkFallback)
                                    Button(booked.contains(tutor.id) ? "Booked" : "Request lesson") {
                                        booked.insert(tutor.id)
                                        message = "Lesson request saved locally for \(tutor.name)."
                                    }
                                    .font(.caption.weight(.semibold))
                                    .padding(.top, 4)
                                    .disabled(booked.contains(tutor.id))
                                }
                            }
                        }
                    }

                    if let message {
                        Text(message)
                            .font(.caption)
                            .foregroundStyle(ExamAceTheme.inkMuted)
                    }
                }
                .padding(20)
            }
            .examAceScreen()
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    TutorsView()
}
