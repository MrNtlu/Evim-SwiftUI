//
//  ShopListView.swift
//  Evim
//
//  Created by Burak on 2025/10/03.
//

import SwiftUI

struct ShoppingListView: View {
    @State private var shoppingLists: [ShoppingList] = MockData.shoppingLists
    @State private var isShoppingMode: Bool = false

    var body: some View {
        NavigationStack {
            if isShoppingMode {
                // TODO: Implement shopping mode UI
                VStack {
                    Text("Shopping Mode")
                        .font(.headline)
                    Spacer()
                }
            } else {
                List {
                    ForEach(shoppingLists) { shoppingList in
                        ShoppingListViewCell(item: shoppingList)
                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                Button {
                                    editItem(shoppingList)
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.blue)

                                Button(role: .destructive) {
                                    deleteItem(shoppingList)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            ShoppingListViewBottomButtons(isShoppingMode: $isShoppingMode)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
        }
        .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
        .navigationTitle(Text("Shopping List"))
    }

    private func deleteItem(_ item: ShoppingList) {
        withAnimation {
            shoppingLists.removeAll { $0.id == item.id }
        }
    }

    private func editItem(_ item: ShoppingList) {
        // Handle edit action
        print("Edit: \(item.name)")
    }
}

#Preview {
    ShoppingListView()
}
