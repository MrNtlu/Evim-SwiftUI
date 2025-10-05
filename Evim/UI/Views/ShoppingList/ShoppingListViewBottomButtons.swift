//
//  ShoppingListViewBottomButtons.swift
//  Evim
//
//  Created by Burak on 2025/10/04.
//

import SwiftUI

struct ShoppingListViewBottomButtons: View {
    @Binding var isShoppingMode: Bool
    @State private var showFinishAlert = false
    @State private var showCancelAlert = false
    private let chipHeight: CGFloat = 42

    var body: some View {
        HStack(spacing: 6) {
            //Main Button
            Button {
                if isShoppingMode {
                    showFinishAlert = true
                } else {
                    withAnimation(.smooth(duration: 0.3)) {
                        isShoppingMode = true
                    }
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
            .geometryGroup()
            .animation(.smooth(duration: 0.3), value: isShoppingMode)
            .alert("Finish Shopping", isPresented: $showFinishAlert) {
                Button("Yes", role: .destructive) {
                    withAnimation(.smooth(duration: 0.3)) {
                        isShoppingMode = false
                    }
                }
            } message: {
                Text("Do you want to finish and save your shopping?")
            }

            //Fab Button
            Button {
                if isShoppingMode {
                    showCancelAlert = true
                } else {
                    print("Add new item")
                }
            } label: {
                Image(systemName: isShoppingMode ? "xmark" : "plus")
                    .contentTransition(.symbolEffect(.replace))
                    .font(.system(size: 24, weight: .semibold))
                    .frame(width: chipHeight, height: chipHeight)
            }
            .buttonStyle(.glassProminent)
            .tint(isShoppingMode ? Color.red : Color.accentColor)
            .alert("Discard Changes", isPresented: $showCancelAlert) {
                Button("Cancel Shopping", role: .destructive) {
                    withAnimation(.smooth(duration: 0.3)) {
                        isShoppingMode = false
                    }
                }
                
                Button("Keep Shopping", role: .cancel) {
                }
            } message: {
                Text("Do you want to cancel shopping?")
            }
            .clipShape(Circle())
            .shadow(color: (isShoppingMode ? Color.red : Color.accentColor).opacity(0.4), radius: 10, x: 0, y: 2)
            .geometryGroup()
            .animation(.smooth(duration: 0.3), value: isShoppingMode)
        }
    }
}

#Preview {
    ShoppingListViewBottomButtons(isShoppingMode: .constant(false))
    
    ShoppingListViewBottomButtons(isShoppingMode: .constant(true))
}
