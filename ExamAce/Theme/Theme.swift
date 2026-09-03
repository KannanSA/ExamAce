import SwiftUI

enum ExamAceTheme {
    static let paper = Color("Paper")
    static let gold = Color("Gold")
    static let ink = Color("Ink")

    static let paperFallback = Color(red: 0.953, green: 0.918, blue: 0.847)
    static let paperDeep = Color(red: 0.910, green: 0.855, blue: 0.745)
    static let card = Color(red: 0.988, green: 0.965, blue: 0.910)
    static let goldFallback = Color(red: 0.753, green: 0.608, blue: 0.275)
    static let goldBright = Color(red: 0.890, green: 0.745, blue: 0.400)
    static let inkFallback = Color(red: 0.180, green: 0.141, blue: 0.090)
    static let inkMuted = Color(red: 0.455, green: 0.392, blue: 0.298)
    static let rust = Color(red: 0.545, green: 0.353, blue: 0.169)
}

struct PaperBackground: View {
    var body: some View {
        ZStack {
            ExamAceTheme.paperFallback
            LinearGradient(
                colors: [
                    Color.white.opacity(0.28),
                    Color.clear,
                    ExamAceTheme.paperDeep.opacity(0.55)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            Canvas { context, size in
                for i in 0..<140 {
                    let x = CGFloat((i * 47) % 97) / 97 * size.width
                    let y = CGFloat((i * 31) % 89) / 89 * size.height
                    let alpha = 0.035 + Double(i % 5) * 0.008
                    context.fill(
                        Path(ellipseIn: CGRect(x: x, y: y, width: 2.2, height: 2.2)),
                        with: .color(ExamAceTheme.inkFallback.opacity(alpha))
                    )
                }
            }
            .allowsHitTesting(false)
        }
        .ignoresSafeArea()
    }
}

struct ExamAceTitle: View {
    var body: some View {
        Text("ExamAce")
            .font(.system(.largeTitle, design: .serif).weight(.medium))
            .foregroundStyle(ExamAceTheme.inkFallback)
            .tracking(0.6)
    }
}

struct PaperCard<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(ExamAceTheme.card)
                    .shadow(color: ExamAceTheme.inkFallback.opacity(0.08), radius: 10, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(ExamAceTheme.goldFallback.opacity(0.18), lineWidth: 1)
            )
    }
}

extension View {
    func examAceScreen() -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(PaperBackground())
    }
}
