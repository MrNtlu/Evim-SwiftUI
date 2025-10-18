//
//  ProductsView.swift
//  Evim
//
//  Created by Burak on 2025/10/04.
//

import SwiftUI

struct ProductsView: View {
    @Environment(ProductStore.self) var productStore
    @Environment(TagStore.self) var tagStore
    @Environment(ThemeStore.self) var themeStore
    @Environment(BannerController.self) private var banner
    // Initial load gate to avoid empty-state flicker and reruns on tab change
    @State private var isInitialLoading: Bool = true
    @State private var didInitialLoad: Bool = false
    @State private var showProductForm = false
    @State private var shoppingListStore = ShoppingListStore()

    // Filter & Search State
    @State private var searchQuery: String = ""
    @State private var selectedTags: Set<UUID> = []
    @FocusState private var isSearchFocused: Bool

    // Quick Add to Shopping List
    @State private var itemFormPresentation: ItemFormPresentation? = nil

    var filteredProducts: [Product] {
        productStore.filteredProducts(searchQuery: searchQuery, tagIds: selectedTags)
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            NavigationStack {
                VStack(spacing: 0) {
                // Filter bar (always show)
                ProductFilterBar(
                    searchQuery: $searchQuery,
                    selectedTags: $selectedTags,
                    availableTags: tagStore.sortedByLabel(),
                    isSearchFocused: $isSearchFocused
                )
                Divider()

                if isInitialLoading || productStore.isLoading {
                    // Loading state
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Loading...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if productStore.products.isEmpty {
                    // Empty state
                    VStack(spacing: 16) {
                        Image(systemName: "square.grid.2x2")
                            .font(.system(size: 64))
                            .foregroundColor(themeStore.primaryColor.opacity(0.5))
                        Text("No Products Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("Tap + to add your first product")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if filteredProducts.isEmpty {
                    // Empty state for filtered results
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 64))
                            .foregroundColor(themeStore.primaryColor.opacity(0.5))
                        Text("No Products Found")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("Try adjusting your filters")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Products list
                    List {
                        if let error = productStore.errorMessage, !error.isEmpty {
                            Section {
                                Text(error).foregroundStyle(.red).font(.footnote)
                            }
                        }
                        ForEach(filteredProducts) { product in
                            ProductViewCell(
                                product: product,
                                onEdit: { updatedProduct in
                                    updateProduct(updatedProduct)
                                },
                                onDelete: {
                                    deleteProduct(product)
                                },
                                onQuickAdd: { product in
                                    itemFormPresentation = .product(product)
                                }
                            )
                            .buttonStyle(.plain)
                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    deleteProduct(product)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .contextMenu {
                                Button(role: .destructive) {
                                    deleteProduct(product)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .contentMargins(.bottom, 80, for: .scrollContent)
                    .listStyle(.plain)
                }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Products")
                .keyboardDismissToolbar()
            }
            .task {
                // Run only once per view lifetime to avoid reloads on tab changes
                guard !didInitialLoad else { return }
                isInitialLoading = true
                // Load prerequisites concurrently to minimize initial delay
                async let tags: Void = tagStore.load()
                async let products: Void = productStore.load()
                _ = await (tags, products)
                isInitialLoading = false
                didInitialLoad = true
            }
            .onChange(of: productStore.errorMessage) { _, msg in
                guard let msg, !msg.isEmpty else { return }
                banner.showError(msg)
                productStore.errorMessage = nil
            }
            .onChange(of: selectedTags) { _, newTags in
                Task {
                    await productStore.loadFilteredByTags(newTags)
                }
            }
            .refreshable {
                await tagStore.load()
                if selectedTags.isEmpty {
                    await productStore.load()
                } else {
                    await productStore.loadFilteredByTags(selectedTags)
                }
            }

            // Floating '+' button anchored to screen, not keyboard
            Button {
                showProductForm = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .semibold))
                    .frame(width: 42, height: 42)
            }
            .buttonStyle(.glassProminent)
            .tint(themeStore.accentColor)
            .clipShape(Circle())
            .shadow(color: themeStore.accentColor.opacity(0.4), radius: 10, x: 0, y: 2)
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
            .ignoresSafeArea(.keyboard)
        }
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $showProductForm) {
            ProductFormModal(
                mode: .create,
                isPresented: $showProductForm,
                onSave: { newProduct in
                    Task {
                        await productStore.load() // ensure household resolved
                        await productStore.add(newProduct)
                        if productStore.errorMessage == nil {
                            banner.show(BannerData(style: .success, message: "Product added"))
                        }
                    }
                }
            )
            .environment(productStore)
            .environment(tagStore)
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
                        await shoppingListStore.load() // ensure household resolved
                        await shoppingListStore.add(newItem)
                        if shoppingListStore.errorMessage == nil {
                            banner.show(BannerData(style: .success, message: "Added to shopping list"))
                        } else if let error = shoppingListStore.errorMessage {
                            banner.showError(error)
                            shoppingListStore.errorMessage = nil
                        }
                    }
                }
            )
            .environment(productStore)
            .environment(tagStore)
            .environment(themeStore)
        }
    }

    private func deleteProduct(_ product: Product) {
        withAnimation { productStore.delete(id: product.id) }
        banner.show(BannerData(style: .warning, message: "Product deleted"))
    }

    private func updateProduct(_ updatedProduct: Product) {
        withAnimation { productStore.update(updatedProduct) }
        banner.show(BannerData(style: .info, message: "Product updated"))
    }
}

#Preview {
    @Previewable @State var productStore = ProductStore()
    @Previewable @State var tagStore = TagStore()
    @Previewable @State var themeStore = ThemeStore()

    ProductsView()
        .environment(productStore)
        .environment(tagStore)
        .environment(themeStore)
}
