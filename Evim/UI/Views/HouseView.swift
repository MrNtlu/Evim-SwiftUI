//
//  HouseView.swift
//  Evim
//
//  Created by Burak on 2025/10/03.
//

import SwiftUI

struct HouseView: View {
    var body: some View {
        NavigationView {
            Text("My Household")
            .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline).navigationTitle(Text("My Household"))
        }
    }
}

#Preview {
    HouseView()
}
