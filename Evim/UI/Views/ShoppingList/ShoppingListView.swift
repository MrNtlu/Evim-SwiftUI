//
//  ShoppingListView.swift
//  Evim
//
//  Created by Burak on 2025/10/03.
//

import SwiftUI

struct ShoppingListView: View {
    @Environment(ProductStore.self) var productStore
    @Environment(TagStore.self) var tagStore
    @Environment(ThemeStore.self) var themeStore
    @Environment(BannerController.self) private var banner
    @State private var store = ShoppingListStore()
    // Initial load gate to avoid empty-state flicker and reruns on tab change
    @State private var isInitialLoading: Bool = true
    @State private var didInitialLoad: Bool = false
    // Local session items used during shopping mode editing
    @State private var shoppingSessionItems: [ShoppingListItem] = []
    @State private var isShoppingMode: Bool = false
    @State private var showProductSelection = false
    @State private var itemFormPresentation: ItemFormPresentation? = nil
    @State private var showTagsView = false
    @State private var showEmptyListAlert = false

    // Filter & Sort State
    @State private var selectedTags: Set<UUID> = []
    @State private var deadlineFilter: DeadlineFilter = .all
    @State private var sortOption: SortOption = .createdAt

    // Computed filtered and sorted list
    // NOTE: This computed property efficiently recalculates only when dependencies change.
    // When migrating to Supabase, move this logic to the repository layer with server-side filtering/sorting.
    var filteredAndSortedItems: [ShoppingListItem] {
        var items = store.items

        // Apply tag filter
        if !selectedTags.isEmpty {
            items = items.filter { item in
                let itemTags = item.tags(from: productStore)
                return itemTags.contains { tag in
                    selectedTags.contains(tag.id)
                }
            }
        }

        // Apply deadline filter
        switch deadlineFilter {
        case .all:
            break
        case .hasDeadline:
            items = items.filter { $0.deadlineDate != nil }
        case .noDeadline:
            items = items.filter { $0.deadlineDate == nil }
        }

        // Apply sorting
        switch sortOption {
        case .createdAt:
            items = items.sorted { $0.createdAt > $1.createdAt }
        case .name:
            items = items.sorted { $0.name(from: productStore) < $1.name(from: productStore) }
        case .deadline:
            items = items.sorted { item1, item2 in
                guard let date1 = item1.deadlineDate else { return false }
                guard let date2 = item2.deadlineDate else { return true }
                return date1 < date2
            }
        case .tag:
            items = items.sorted { item1, item2 in
                let tags1 = item1.tags(from: productStore)
                let tags2 = item2.tags(from: productStore)
                let name1 = tags1.first?.label ?? ""
                let name2 = tags2.first?.label ?? ""
                return name1 < name2
            }
        }

        return items
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack {
            VStack(spacing: 0) {
                // Filter bar (only in regular mode)
                if !isShoppingMode {
                    ShoppingListFilterBar(
                        selectedTags: $selectedTags,
                        deadlineFilter: $deadlineFilter,
                        sortOption: $sortOption,
                        availableTags: tagStore.sortedByLabel()
                    )
                    Divider()
                }

                // List content
                if isShoppingMode {
                    if isInitialLoading || store.isLoading {
                        // Loading state
                        GeometryReader { geometry in
                            VStack(spacing: 16) {
                                ProgressView()
                                    .scaleEffect(1.5)
                                Text("Loading...")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, minHeight: geometry.size.height)
                        }
                    } else if shoppingSessionItems.isEmpty {
                        // Empty state for shopping mode (centered with pull-to-refresh)
                        GeometryReader { geometry in
                            ScrollView {
                                VStack(spacing: 16) {
                                    if let error = store.errorMessage, !error.isEmpty {
                                        Text(error).foregroundStyle(.red).font(.footnote)
                                    }
                                    Image(systemName: "cart.badge.plus")
                                        .font(.system(size: 64))
                                        .foregroundColor(themeStore.primaryColor.opacity(0.5))
                                    Text("No Items Yet")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                    Text("Pull to refresh or tap + to add")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity, minHeight: geometry.size.height)
                            }
                            .refreshable {
                                await tagStore.load()
                                await productStore.load()
                                await store.load()
                                shoppingSessionItems = store.items
                            }
                        }
                    } else {
                        List {
                            if let error = store.errorMessage, !error.isEmpty {
                                Section { Text(error).foregroundStyle(.red).font(.footnote) }
                            }
                            ForEach($shoppingSessionItems) { $shoppingList in
                                ShoppingListViewShoppingCell(
                                    item: $shoppingList,
                                    productStore: productStore
                                )
                                .buttonStyle(.plain)
                            }
                        }
                        .refreshable {
                            await tagStore.load()
                            await productStore.load()
                            await store.load()
                            shoppingSessionItems = store.items
                        }
                        .contentMargins(.bottom, 80, for: .scrollContent)
                        .listStyle(.plain)
                    }
                } else {
                    if isInitialLoading || store.isLoading {
                        // Loading state
                        GeometryReader { geometry in
                            VStack(spacing: 16) {
                                ProgressView()
                                    .scaleEffect(1.5)
                                Text("Loading...")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, minHeight: geometry.size.height)
                        }
                    } else if filteredAndSortedItems.isEmpty {
                        // Empty state for regular mode (centered with pull-to-refresh)
                        GeometryReader { geometry in
                            ScrollView {
                                VStack(spacing: 16) {
                                    if let error = store.errorMessage, !error.isEmpty {
                                        Text(error).foregroundStyle(.red).font(.footnote)
                                    }
                                    Image(systemName: "cart.badge.plus")
                                        .font(.system(size: 64))
                                        .foregroundColor(themeStore.primaryColor.opacity(0.5))
                                    Text("No Items Yet")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                    Text("Pull to refresh or tap + to add")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity, minHeight: geometry.size.height)
                            }
                            .refreshable {
                                await tagStore.load()
                                await productStore.load()
                                await store.load()
                            }
                        }
                    } else {
                        List {
                            if let error = store.errorMessage, !error.isEmpty {
                                Section { Text(error).foregroundStyle(.red).font(.footnote) }
                            }
                            ForEach(filteredAndSortedItems) { shoppingList in
                                ShoppingListViewCell(
                                    item: shoppingList,
                                    productStore: productStore,
                                    onEdit: { updatedItem in
                                        updateItem(updatedItem)
                                    },
                                    onDelete: {
                                        deleteItem(shoppingList)
                                    }
                                )
                                .buttonStyle(.plain)
                                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        deleteItem(shoppingList)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                .contextMenu {
                                    Button(role: .destructive) {
                                        deleteItem(shoppingList)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .refreshable {
                            await tagStore.load()
                            await productStore.load()
                            await store.load()
                        }
                        .contentMargins(.bottom, 80, for: .scrollContent)
                        .listStyle(.plain)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Shopping List")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showTagsView = true
                    } label: {
                        Image(systemName: "tag")
                    }
                }

                ToolbarItem(placement: .principal) { EmptyView() } // iOS 18 fix
            }
            .keyboardDismissToolbar()
        }
        // Floating bottom buttons anchored to screen, not keyboard
        ShoppingListViewBottomButtons(
            isShoppingMode: $isShoppingMode,
            onFinishShopping: finishShopping,
            onAddItem: { showProductSelection = true },
            onSelectProduct: { showProductSelection = true },
            onManualEntry: {
                itemFormPresentation = .manual
            },
            onStartShopping: {
                // Validate: check if actual items exist (not just filtered out)
                if store.items.isEmpty {
                    showEmptyListAlert = true
                    return false
                }
                return true
            }
        )
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .ignoresSafeArea(.keyboard)
        }
        // Keep layout stable when the keyboard shows
        .ignoresSafeArea(.keyboard)
        .task {
            // Run only once per view lifetime to avoid reloads on tab changes
            guard !didInitialLoad else { return }
            isInitialLoading = true
            // Load prerequisites concurrently to minimize initial delay
            async let tags: Void = tagStore.load()
            async let products: Void = productStore.load()
            async let items: Void = store.load()
            _ = await (tags, products, items)
            isInitialLoading = false
            didInitialLoad = true
        }
        .refreshable {
            await tagStore.load()
            await productStore.load()
            await store.load()
        }
        .onChange(of: store.errorMessage) { _, msg in
            guard let msg, !msg.isEmpty else { return }
            banner.showError(msg)
            store.errorMessage = nil
        }
        .onChange(of: isShoppingMode) { _, newValue in
            if newValue {
                // Clear filters when shopping mode starts
                selectedTags.removeAll()
                deadlineFilter = .all
                sortOption = .createdAt

                // Start shopping session with current items snapshot
                shoppingSessionItems = store.items
            } else {
                shoppingSessionItems.removeAll()
            }
        }
        
        .alert("No Items in Shopping List", isPresented: $showEmptyListAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Add items to your shopping list before starting shopping mode.")
        }
        .sheet(isPresented: $showProductSelection) {
            ProductSelectionSheet(
                isPresented: $showProductSelection,
                onProductSelected: { product in
                    itemFormPresentation = .product(product)
                },
                onManualEntry: {
                    itemFormPresentation = .manual
                }
            )
            .environment(productStore)
            .environment(themeStore)
        }
        .sheet(item: $itemFormPresentation) { presentation in
            ShoppingListItemFormModal(
                mode: .create(product: presentation.product),
                productStore: productStore,
                currentUser: MockData.user,
                isPresented: Binding(
                    get: { itemFormPresentation != nil },
                    set: { if !$0 { itemFormPresentation = nil } }
                ),
                onSave: { newItem in
                    Task {
                        await store.load() // ensure household resolved
                        await store.add(newItem)
                        if store.errorMessage == nil {
                            banner.show(BannerData(style: .success, message: "Item added"))
                        }
                    }
                }
            )
            .environment(productStore)
            .environment(tagStore)
            .environment(themeStore)
        }
        .sheet(isPresented: $showTagsView) {
            TagsListView()
                .environment(tagStore)
                .environment(themeStore)
                .bannerHost(banner)
        }
    }

    private func deleteItem(_ item: ShoppingListItem) {
        Task {
            await store.remove(item)
            if store.errorMessage == nil {
                banner.show(BannerData(style: .warning, message: "Item deleted"))
            }
        }
    }

    private func updateItem(_ updatedItem: ShoppingListItem) {
        Task {
            await store.update(updatedItem)
            if store.errorMessage == nil {
                banner.show(BannerData(style: .info, message: "Item updated"))
            }
        }
    }

    private func finishShopping() {
        // Capture a snapshot of current session items before UI toggles shopping mode off
        let sessionSnapshot = shoppingSessionItems
        Task {
            await store.applyShoppingSessionChanges(from: sessionSnapshot)
            await store.load()
            if store.errorMessage == nil {
                banner.show(BannerData(style: .success, message: "Shopping saved"))
            }
        }
    }
}

#Preview {
    @Previewable @State var productStore = ProductStore()
    @Previewable @State var tagStore = TagStore()
    @Previewable @State var themeStore = ThemeStore()

    ShoppingListView()
        .environment(productStore)
        .environment(tagStore)
        .environment(themeStore)
}
