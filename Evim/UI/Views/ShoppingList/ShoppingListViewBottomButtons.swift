//
//  ShoppingListViewBottomButtons.swift
//  Evim
//
//  Created by Burak on 2025/10/04.
//

import SwiftUI

struct ShoppingListViewBottomButtons: View {
    @Binding var isShoppingMode: Bool
    private let chipHeight: CGFloat = 42

    var body: some View {
        HStack(spacing: 6) {
            Button {
                withAnimation(.smooth(duration: 0.3)) {
                    isShoppingMode.toggle()
                }
            } label: {
                HStack {
                    Image(systemName: isShoppingMode ? "creditcard" : "cart")
                        .contentTransition(.symbolEffect(.replace))
                        .padding()

                    Text(isShoppingMode ? "Finish Shopping" : "Start Shopping")
                        .font(.headline)
                        .contentTransition(.numericText())
                }
                .frame(maxWidth: .infinity)
                .frame(height: 42)
            }
            .buttonStyle(.glass)
            .animation(.smooth(duration: 0.3), value: isShoppingMode)

            Button {
                if isShoppingMode {
                    withAnimation(.smooth(duration: 0.3)) {
                        isShoppingMode = false
                    }
                } else {
                    // Add new item action
                    print("Add new item")
                }
            } label: {
                Image(systemName: isShoppingMode ? "xmark" : "plus")
                    .contentTransition(.symbolEffect(.replace))
                    .font(.system(size: 24, weight: .semibold))
                    .frame(width: chipHeight, height: chipHeight)
            }
//            .background(isShoppingMode ? Color.red : Color.accentColor, in: Circle())
            .buttonStyle(.glassProminent)
            .tint(isShoppingMode ? Color.red : Color.accentColor)
            .clipShape(Circle())
//            .foregroundStyle(.white)
            .shadow(color: (isShoppingMode ? Color.red : Color.accentColor).opacity(0.4), radius: 10, x: 0, y: 2)
            .animation(.smooth(duration: 0.3), value: isShoppingMode)
        }
    }
}

#Preview {
    ShoppingListViewBottomButtons(isShoppingMode: .constant(false))
    
    ShoppingListViewBottomButtons(isShoppingMode: .constant(true))
}
