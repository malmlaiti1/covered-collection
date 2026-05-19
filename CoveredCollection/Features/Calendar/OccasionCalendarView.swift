import SwiftUI

struct OccasionCalendarView: View {
    @State private var path: [CalendarRoute] = []
    @State private var showAddSheet = false

    private var sortedEvents: [CalendarEvent] {
        MockData.events.sorted { $0.daysUntil < $1.daysUntil }
    }

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: CoveredSpacing.md) {
                    header
                    VStack(spacing: CoveredSpacing.sm) {
                        ForEach(sortedEvents) { event in
                            EventRow(event: event) {
                                path.append(.eventDetail(event.id))
                            }
                        }
                    }
                    addPersonalOccasion
                }
                .padding(.horizontal, CoveredSpacing.lg)
                .padding(.top, 4)
                .padding(.bottom, CoveredSpacing.xl * 2)
            }
            .background(Color.coveredCream.ignoresSafeArea())
            .navigationTitle("Your Modest Year")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.coveredCream, for: .navigationBar)
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
        VStack(alignment: .leading, spacing: 4) {
            Text("Upcoming")
                .coveredSmallCaps().foregroundStyle(.coveredMuted)
            Text("Plan outfits ahead. We'll match pieces 14 days out.")
                .font(.coveredBody)
                .foregroundStyle(.coveredMuted)
        }
        .padding(.bottom, 4)
    }

    private var addPersonalOccasion: some View {
        CoveredButton(title: "+ Add a personal occasion", kind: .secondary) {
            showAddSheet = true
        }
        .padding(.top, CoveredSpacing.md)
    }
}

// MARK: - Countdown formatting

enum EventCountdown {
    static func text(forDays days: Int) -> String {
        if days <= 0 { return "Today" }
        if days < 30 { return "In \(days) day\(days == 1 ? "" : "s")" }
        let months = Int((Double(days) / 30.0).rounded())
        return "In ~\(months) month\(months == 1 ? "" : "s")"
    }
}

// MARK: - Event Row

private struct EventRow: View {
    let event: CalendarEvent
    let onTap: () -> Void

    private var dateText: String {
        event.date.formatted(.dateTime.month(.wide).day().year())
    }

    var body: some View {
        Button(action: onTap) {
            CoveredCard(padding: 14) {
                HStack(alignment: .top, spacing: 14) {
                    Image(systemName: event.category.symbol)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.coveredCream)
                        .frame(width: 44, height: 44)
                        .background(Color.coveredOlive)
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 2) {
                        Text(event.name)
                            .font(.coveredTitle)
                            .foregroundStyle(.coveredInk)
                        Text(dateText)
                            .font(.coveredCaption)
                            .foregroundStyle(.coveredMuted)
                        if let edit = event.recommendedEditName {
                            HStack(spacing: 5) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 11))
                                Text("Recommended: \(edit)")
                                    .font(.system(size: 11.5, weight: .medium))
                            }
                            .foregroundStyle(.coveredOlive)
                            .padding(.top, 4)
                        }
                    }

                    Spacer(minLength: 4)

                    VStack(alignment: .trailing, spacing: 4) {
                        Text(EventCountdown.text(forDays: event.daysUntil))
                            .font(.coveredCaption.weight(.semibold))
                            .foregroundStyle(.coveredOlive)
                        Image(systemName: "chevron.right")
                            .font(.caption2)
                            .foregroundStyle(.coveredMuted)
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Event Detail

private struct EventDetailView: View {
    let event: CalendarEvent

    private var recommendedProducts: [Product] {
        // Show DNA-matched dresses/outerwear as top picks, excluding accessories.
        MockData.products
            .filter { $0.category == .dresses || $0.category == .outerwear }
            .prefix(4)
            .map { $0 }
    }

    private var accessories: [Product] {
        MockData.products.filter { $0.category == .accessories }.prefix(3).map { $0 }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CoveredSpacing.lg) {
                hero
                    .padding(.horizontal, CoveredSpacing.lg)
                editCard
                    .padding(.horizontal, CoveredSpacing.lg)
                topPicks
                completeTheLook
                    .padding(.horizontal, CoveredSpacing.lg)
                CoveredButton(title: "Reserve for this event", kind: .primary) {}
                    .padding(.horizontal, CoveredSpacing.lg)
            }
            .padding(.top, 4)
            .padding(.bottom, CoveredSpacing.xl * 2)
        }
        .background(Color.coveredCream.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "ellipsis")
                    .foregroundStyle(.coveredInk)
            }
        }
    }

    private var hero: some View {
        let dateLine = event.date.formatted(.dateTime.weekday(.wide).month(.wide).day())
        return ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [
                    Color(red: 0.78, green: 0.57, blue: 0.51),   // dusty rose
                    Color(red: 0.72, green: 0.56, blue: 0.30)    // brass
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            NoiseOverlay(opacity: 0.06)
            RadialGradient(
                colors: [Color.white.opacity(0.15), .clear],
                center: UnitPoint(x: 0.25, y: 0.20),
                startRadius: 0,
                endRadius: 180
            )

            VStack {
                HStack(alignment: .top) {
                    Image(systemName: event.category.symbol)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.coveredCream)
                        .frame(width: 44, height: 44)
                        .background(Color.white.opacity(0.18))
                        .clipShape(Circle())
                    Spacer()
                    Text(EventCountdown.text(forDays: event.daysUntil))
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.coveredCream)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.18))
                        .clipShape(Capsule())
                }
                Spacer()
                VStack(alignment: .leading, spacing: 6) {
                    Text(dateLine.uppercased())
                        .font(.system(size: 11, weight: .medium))
                        .tracking(2.5)
                        .foregroundStyle(Color.coveredCream.opacity(0.86))
                    Text(event.name)
                        .font(.coveredDisplay)
                        .foregroundStyle(.coveredCream)
                        .shadow(color: .black.opacity(0.16), radius: 10, x: 0, y: 1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(22)
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color(red: 0.18, green: 0.14, blue: 0.08).opacity(0.16), radius: 14, x: 0, y: 12)
    }

    private var editCard: some View {
        let editName = event.recommendedEditName ?? "Occasion Edit"
        return CoveredCard(background: .coveredTagBg, stroke: nil) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("The Edit")
                        .coveredSmallCaps()
                        .foregroundStyle(.coveredMuted)
                    Text(editName)
                        .font(.coveredTitle)
                        .foregroundStyle(.coveredInk)
                    Text("18 looks, all DNA-matched")
                        .font(.coveredCaption)
                        .foregroundStyle(.coveredMuted)
                }
                Spacer()
                Button {} label: {
                    Text("View edit")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.coveredCream)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color.coveredOlive)
                        .clipShape(Capsule())
                }
            }
        }
    }

    private var topPicks: some View {
        VStack(alignment: .leading, spacing: CoveredSpacing.sm) {
            Text("Top picks for you")
                .coveredSmallCaps()
                .foregroundStyle(.coveredMuted)
                .padding(.horizontal, CoveredSpacing.lg)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(recommendedProducts) { product in
                        VStack(alignment: .leading, spacing: 6) {
                            ProductImageView(product: product, aspect: 4.0/5.0, cornerRadius: 12)
                                .frame(width: 150)
                            Text(product.name)
                                .font(.coveredProductName)
                                .foregroundStyle(.coveredInk)
                                .lineLimit(2)
                                .frame(width: 150, alignment: .leading)
                            Text(CoveredFormatters.priceText(product.priceRetail))
                                .font(.coveredCaption)
                                .foregroundStyle(.coveredOlive)
                        }
                    }
                }
                .padding(.horizontal, CoveredSpacing.lg)
            }
        }
    }

    private var completeTheLook: some View {
        VStack(alignment: .leading, spacing: CoveredSpacing.sm) {
            Text("Complete the look")
                .coveredSmallCaps()
                .foregroundStyle(.coveredMuted)
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 10),
                    GridItem(.flexible(), spacing: 10),
                    GridItem(.flexible(), spacing: 10)
                ],
                spacing: 10
            ) {
                ForEach(accessories) { product in
                    ProductImageView(product: product, aspect: 1.0, cornerRadius: 10, showsBrandLabel: false)
                }
            }
        }
    }
}

// MARK: - Add Personal Occasion

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
            .background(Color.coveredCream)
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
