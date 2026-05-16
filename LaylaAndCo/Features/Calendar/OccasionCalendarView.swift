import SwiftUI

struct OccasionCalendarView: View {
    @State private var path: [CalendarRoute] = []
    @State private var showAddSheet = false

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: LaylaSpacing.lg) {
                    header
                    ForEach(MockData.events) { event in
                        EventRow(event: event) {
                            path.append(.planOutfit(event.id))
                        }
                    }
                    addPersonalOccasion
                }
                .padding(.horizontal, LaylaSpacing.lg)
                .padding(.vertical, LaylaSpacing.lg)
            }
            .background(Color.laylaCream.ignoresSafeArea())
            .navigationTitle("Your Modest Year")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color.laylaCream, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationDestination(for: CalendarRoute.self) { route in
                switch route {
                case .eventDetail(let id):
                    if let evt = MockData.events.first(where: { $0.id == id }) {
                        EventDetailView(event: evt)
                    }
                case .planOutfit(let id):
                    if let evt = MockData.events.first(where: { $0.id == id }) {
                        EventDetailView(event: evt)
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddPersonalOccasionSheet()
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: LaylaSpacing.xs) {
            Text("Upcoming")
                .laylaSmallCaps().foregroundStyle(.laylaMuted)
            Text("Plan outfits ahead.")
                .font(.laylaBody)
                .foregroundStyle(.laylaMuted)
        }
    }

    private var addPersonalOccasion: some View {
        LaylaButton(title: "+ Add a personal occasion", kind: .secondary) {
            showAddSheet = true
        }
        .padding(.top, LaylaSpacing.md)
    }
}

private struct EventRow: View {
    let event: CalendarEvent
    let onTap: () -> Void

    private var dateText: String {
        event.date.formatted(.dateTime.month(.wide).day().year())
    }

    private var countdownText: String {
        let days = event.daysUntil
        if days <= 0 { return "Today" }
        if days < 30 { return "In \(days) day\(days == 1 ? "" : "s")" }
        let months = days / 30
        return "In ~\(months) month\(months == 1 ? "" : "s")"
    }

    var body: some View {
        Button(action: onTap) {
            LaylaCard {
                HStack(alignment: .top, spacing: LaylaSpacing.md) {
                    VStack {
                        Image(systemName: event.category.symbol)
                            .font(.title3)
                            .foregroundStyle(.laylaCream)
                            .frame(width: 44, height: 44)
                            .background(Color.laylaOlive)
                            .clipShape(Circle())
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(event.name)
                            .font(.laylaTitle)
                            .foregroundStyle(.laylaInk)
                        Text(dateText)
                            .font(.laylaCaption)
                            .foregroundStyle(.laylaMuted)
                        if let edit = event.recommendedEditName {
                            HStack(spacing: 4) {
                                Image(systemName: "sparkles")
                                Text("Recommended: \(edit)")
                            }
                            .font(.caption2)
                            .foregroundStyle(.laylaOlive)
                            .padding(.top, 2)
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(countdownText)
                            .font(.laylaCaption.weight(.semibold))
                            .foregroundStyle(.laylaOlive)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.laylaMuted)
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
}

private struct EventDetailView: View {
    let event: CalendarEvent

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: LaylaSpacing.lg) {
                Text(event.name)
                    .font(.laylaDisplay)
                    .foregroundStyle(.laylaInk)
                Text(event.date.formatted(.dateTime.weekday(.wide).month(.wide).day().year()))
                    .font(.laylaBody)
                    .foregroundStyle(.laylaMuted)

                if let edit = event.recommendedEditName {
                    LaylaCard {
                        VStack(alignment: .leading, spacing: LaylaSpacing.sm) {
                            Text(edit).laylaSmallCaps().foregroundStyle(.laylaMuted)
                            Text("We've curated a capsule of looks for this occasion.")
                                .font(.laylaBody).foregroundStyle(.laylaInk)
                            LaylaButton(title: "View the edit", kind: .primary) {}
                                .padding(.top, LaylaSpacing.sm)
                        }
                    }
                }
            }
            .padding(LaylaSpacing.lg)
        }
        .background(Color.laylaCream.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct AddPersonalOccasionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var date: Date = .now

    var body: some View {
        NavigationStack {
            Form {
                Section("Occasion") {
                    TextField("Name", text: $name)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
            }
            .background(Color.laylaCream)
            .scrollContentBackground(.hidden)
            .navigationTitle("Add occasion")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") { dismiss() }
                        .fontWeight(.semibold)
                        .disabled(name.isEmpty)
                }
            }
        }
    }
}

#Preview {
    OccasionCalendarView()
        .environment(UserProfileStore())
}
