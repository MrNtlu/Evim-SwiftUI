//
//  ContentView.swift
//  Evim
//
//  Created by Burak on 2025/10/03.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    var body: some View {
        TabView {
            Text("Main Page")
        }
        TabView {
            Text("Profile Page")
        }
    }
}

#Preview {
    MainTabView()
}
