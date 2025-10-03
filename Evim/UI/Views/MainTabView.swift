//
//  ContentView.swift
//  Evim
//
//  Created by Burak on 2025/10/03.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    
    private enum Tab: Int {
        case list
        case history
        case home
    }
    
    @State private var selectedTab: Tab = .list
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ShoppingListView()
                .tabItem {
                    Label("List", systemImage: "cart")
                        .environment(\.symbolVariants, selectedTab == .list ? .fill : .none)
                }
                .tag(Tab.list)
            
            ShoppingHistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                        .environment(\.symbolVariants, selectedTab == .history ? .fill : .none)
                }
                .tag(Tab.history)
            
            HouseView()
                .tabItem {
                    Label("Home", systemImage: "house")
                        .environment(\.symbolVariants, selectedTab == .home ? .fill : .none)
                }
                .tag(Tab.home)
        }
    }
}

#Preview {
    MainTabView()
}
