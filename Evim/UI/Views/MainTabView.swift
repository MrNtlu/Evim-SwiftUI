//
//  ContentView.swift
//  Evim
//
//  Created by Burak on 2025/10/03.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    
    private enum TabEnum: Int {
        case list
        case history
        case home
        case products
    }
    
    @State private var selectedTab: TabEnum = .list
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("List", systemImage: "cart", value: TabEnum.list) {
                ShoppingListView()
            }
            
            Tab("Products", systemImage: "square.grid.2x2", value: TabEnum.products) {
                ProductsView()
            }

            Tab("History", systemImage: "clock", value: TabEnum.history) {
                ShoppingHistoryView()
            }

            Tab("Home", systemImage: "house", value: TabEnum.home) {
                HouseView()
            }
        }
    }
}

#Preview {
    MainTabView()
}
