import SwiftUI

struct AppRoot: View {
    @State private var store = UserProfileStore()
    @State private var tabSelection = AppTabSelection()
    @AppStorage(UserProfileStore.onboardingFlagKey) private var hasCompletedOnboarding: Bool = false
    @State private var didBootstrap = false

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                MainTabView()
            } else {
                ModestyDNAOnboardingView()
            }
        }
        .tint(.laylaOlive)
        .environment(store)
        .environment(tabSelection)
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
