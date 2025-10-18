//
//  ShoppingHistoryView.swift
//  Evim
//
//  Created by Burak on 2025/10/03.
//

import SwiftUI

struct ShoppingHistoryView: View {
    @State private var store = ShoppingHistoryStore()
    @Environment(ThemeStore.self) private var themeStore
    @Environment(HouseholdSettingsStore.self) private var settingsStore
    @Environment(BannerController.self) private var banner

    var body: some View {
        NavigationStack {
            Group {
                if store.isLoading {
                    // Loading state
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Loading...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if store.histories.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "clock")
                            .font(.system(size: 64))
                            .foregroundColor(themeStore.primaryColor.opacity(0.5))
                        Text("No History Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("Finish a shopping session to see it here")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        if let error = store.errorMessage, !error.isEmpty {
                            Section { Text(error).foregroundStyle(.red).font(.footnote) }
                        }
                        ForEach(store.histories) { history in
                            NavigationLink(value: history.id) {
                                HistoryRow(history: history, currencySymbol: settingsStore.currency.symbol)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                if history.isArchived {
                                    Button {
                                        Task { await store.setArchived(history.id, archived: false) }
                                    } label: { Label("Unarchive", systemImage: "tray.and.arrow.up") }
                                    .tint(.blue)
                                } else {
                                    Button {
                                        Task { await store.setArchived(history.id, archived: true) }
                                    } label: { Label("Archive", systemImage: "archivebox") }
                                    .tint(.orange)
                                }
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                if history.isArchived {
                                    Button(role: .destructive) {
                                        Task { await store.delete(history.id) }
                                    } label: { Label("Delete", systemImage: "trash") }
                                }
                            }
                            .contextMenu {
                                if history.isArchived {
                                    Button(role: .destructive) { Task { await store.delete(history.id) } } label: { Label("Delete", systemImage: "trash") }
                                    Button { Task { await store.setArchived(history.id, archived: false) } } label: { Label("Unarchive", systemImage: "tray.and.arrow.up") }
                                } else {
                                    Button { Task { await store.setArchived(history.id, archived: true) } } label: { Label("Archive", systemImage: "archivebox") }
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Shopping History")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: UUID.self) { historyId in
                if let history = store.histories.first(where: { $0.id == historyId }) {
                    ShoppingHistoryDetailView(history: history)
                        .environment(store)
                        .environment(themeStore)
                        .environment(settingsStore)
                }
            }
        }
        .task { await store.load() }
        .refreshable { await store.load() }
        .onChange(of: store.errorMessage) { _, msg in
            guard let msg, !msg.isEmpty else { return }
            banner.showError(msg)
            store.errorMessage = nil
        }
    }
}

private struct HistoryRow: View {
    let history: ShoppingHistory
    let currencySymbol: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Text(DateFormatter.mediumDate.string(from: history.date))
                    .font(.headline)
                if history.isArchived {
                    Text("Archived")
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(.systemGray5))
                        .cornerRadius(6)
                }
                Spacer()
                if let total = history.totalSpent {
                    Text("\(currencySymbol) \(format(total))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Text("By: \(displayName(history.doneBy))")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }

    private func format(_ value: Double) -> String {
        let nf = NumberFormatter()
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 2
        return nf.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    private func displayName(_ user: User) -> String {
        let n = user.name.trimmingCharacters(in: .whitespaces)
        if !n.isEmpty { return n }
        let e = user.email.trimmingCharacters(in: .whitespaces)
        if !e.isEmpty { return e }
        return "Unknown"
    }
}

#Preview {
    @Previewable @State var themeStore = ThemeStore()
    @Previewable @State var settings = HouseholdSettingsStore()

    ShoppingHistoryView()
        .environment(themeStore)
        .environment(settings)
}
