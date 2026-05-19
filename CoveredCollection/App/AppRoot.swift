import SwiftUI

struct AppRoot: View {
    @State private var store = UserProfileStore()
    @State private var tabSelection = AppTabSelection()
    @State private var theme = ThemeStore.shared
    @AppStorage(UserProfileStore.onboardingFlagKey) private var hasCompletedOnboarding: Bool = false
    @AppStorage("isSignedIn") private var isSignedIn = false
    @State private var didBootstrap = false

    var body: some View {
        // Reading `theme.accent` inside body makes the entire tree depend on it,
        // so changing the accent rebuilds every screen with the new brand color.
        let _ = theme.accent
        return Group {
            if !isSignedIn {
                LoginView()
            } else if hasCompletedOnboarding {
                MainTabView()
            } else {
                ModestyDNAOnboardingView()
            }
        }
        .tint(.coveredOlive)
        .environment(store)
        .environment(tabSelection)
        .environment(theme)
        #if DEBUG
        .environment(DevModeStore.shared)
        #endif
        .task {
            guard !didBootstrap else { return }
            didBootstrap = true
            await store.bootstrap()
        }
    }
}

#Preview {
    AppRoot()
}
