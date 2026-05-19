import SwiftUI

struct MainTabView: View {
    @Environment(AppTabSelection.self) private var tabSelection

    var body: some View {
        @Bindable var sel = tabSelection
        TabView(selection: $sel.selected) {
            ClosetView()
                .tabItem { Label("Closet", systemImage: "tshirt") }
                .tag(AppTab.closet)

            OccasionCalendarView()
                .tabItem { Label("Calendar", systemImage: "calendar") }
                .tag(AppTab.calendar)

            MyBoxView()
                .tabItem { Label("My Box", systemImage: "shippingbox") }
                .tag(AppTab.myBox)

            SavedView()
                .tabItem { Label("Saved", systemImage: "heart") }
                .tag(AppTab.saved)

            AccountView()
                .tabItem { Label("Account", systemImage: "person.crop.circle") }
                .tag(AppTab.account)

            #if DEBUG
            if DevModeStore.shared.isEnabled {
                DevUploadView()
                    .tabItem { Label("Upload", systemImage: "square.and.arrow.up") }
                    .tag(AppTab.devUpload)
            }
            #endif
        }
        .toolbarBackground(Color.coveredCream, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}

#Preview {
    MainTabView()
        .environment(UserProfileStore())
        .environment(AppTabSelection())
}
