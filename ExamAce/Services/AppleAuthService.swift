import Combine
import Foundation

/// Sign in with Apple is stubbed until the capability is added in Xcode.
///
/// TODO: Enable Sign in with Apple in Signing & Capabilities, then complete
/// `ASAuthorizationAppleIDProvider` in `signIn()`.
@MainActor
final class AppleAuthService: ObservableObject {
    @Published var isSignedIn: Bool = false
    @Published var displayName: String = "Student"
    @Published var statusMessage: String = "Sign in with Apple is not enabled in this build"

    func signIn() {
        // TODO: Create ASAuthorizationAppleIDProvider().createRequest(),
        // present ASAuthorizationController, and persist the user identifier.
        isSignedIn = true
        displayName = "Local Student"
        statusMessage = "Signed in locally. Replace this stub after enabling Sign in with Apple."
    }

    func signOut() {
        isSignedIn = false
        displayName = "Student"
        statusMessage = "Sign in with Apple is not enabled in this build"
    }
}
