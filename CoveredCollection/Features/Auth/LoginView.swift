import SwiftUI

/// App login screen. Any non-empty credentials sign in as a regular user.
/// Entering the dev credentials (`dev` / `Nanoose2!`) also enables dev mode.
struct LoginView: View {
    @AppStorage("isSignedIn") private var isSignedIn = false
    @State private var username = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var attempts = 0
    @FocusState private var focusedField: Field?

    private enum Field { case username, password }

    var body: some View {
        ZStack {
            Color.coveredCream.ignoresSafeArea()

            ScrollView {
                VStack(spacing: CoveredSpacing.lg) {
                    header
                    formCard
                    Spacer(minLength: CoveredSpacing.xl)
                }
                .padding(.horizontal, CoveredSpacing.lg)
                .padding(.top, CoveredSpacing.xl * 2)
                .frame(minHeight: UIScreen.main.bounds.height * 0.85)
            }
        }
        .onAppear { focusedField = .username }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: CoveredSpacing.sm) {
            Image(systemName: "sparkles")
                .font(.system(size: 36, weight: .light))
                .foregroundStyle(.coveredOlive)

            Text("The Covered Collection")
                .font(.system(.title2, design: .serif).weight(.medium))
                .foregroundStyle(.coveredInk)

            Text("Sign in to your account")
                .font(.coveredCaption)
                .foregroundStyle(.coveredMuted)
        }
        .padding(.bottom, CoveredSpacing.lg)
    }

    // MARK: - Form

    private var formCard: some View {
        VStack(spacing: CoveredSpacing.md) {
            field(
                title: "Username",
                text: $username,
                isSecure: false,
                focus: .username,
                submit: { focusedField = .password }
            )

            field(
                title: "Password",
                text: $password,
                isSecure: true,
                focus: .password,
                submit: attemptLogin
            )

            if let errorMessage {
                Text(errorMessage)
                    .font(.coveredCaption)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .transition(.opacity)
            }

            CoveredButton(title: "Sign In", kind: .primary) {
                attemptLogin()
            }
            .disabled(username.isEmpty || password.isEmpty)
            .opacity(username.isEmpty || password.isEmpty ? 0.5 : 1.0)
            .padding(.top, CoveredSpacing.sm)

            #if DEBUG
            devHint
                .padding(.top, CoveredSpacing.md)
            #endif
        }
        .padding(CoveredSpacing.lg)
        .background(Color.coveredSurface)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.coveredBorder, lineWidth: 1)
        )
    }

    @ViewBuilder
    private func field(
        title: String,
        text: Binding<String>,
        isSecure: Bool,
        focus: Field,
        submit: @escaping () -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .coveredSmallCaps()
                .foregroundStyle(.coveredMuted)

            Group {
                if isSecure {
                    SecureField("", text: text)
                        .textContentType(.password)
                } else {
                    TextField("", text: text)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textContentType(.username)
                }
            }
            .font(.body)
            .foregroundStyle(.coveredInk)
            .padding(.horizontal, CoveredSpacing.md)
            .padding(.vertical, 12)
            .background(Color.coveredCream)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color.coveredBorder, lineWidth: 1)
            )
            .focused($focusedField, equals: focus)
            .submitLabel(focus == .username ? .next : .go)
            .onSubmit(submit)
        }
    }

    #if DEBUG
    private var devHint: some View {
        HStack(spacing: CoveredSpacing.sm) {
            Image(systemName: "hammer.fill")
                .font(.caption)
                .foregroundStyle(.coveredMuted)
            Text("Developers: use dev credentials to unlock the Upload tab.")
                .font(.caption2)
                .foregroundStyle(.coveredMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    #endif

    // MARK: - Auth

    private func attemptLogin() {
        let trimmedUser = username.trimmingCharacters(in: .whitespaces)
        let trimmedPass = password

        guard !trimmedUser.isEmpty, !trimmedPass.isEmpty else {
            return
        }

        // Dev credentials check (only in DEBUG builds).
        #if DEBUG
        if DevModeStore.shared.authenticate(username: trimmedUser, password: trimmedPass) {
            DevModeStore.shared.isEnabled = true
            isSignedIn = true
            return
        }
        #endif

        // Regular sign-in: any non-empty credentials work in this prototype.
        // A real app would call an auth service here.
        attempts += 1
        if attempts > 0 {
            // Accept any non-empty credentials.
            isSignedIn = true
        } else {
            withAnimation(.easeInOut(duration: 0.2)) {
                errorMessage = "Invalid credentials."
            }
            password = ""
            focusedField = .password
        }
    }
}

#Preview {
    LoginView()
}
