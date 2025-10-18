//
//  EvimApp.swift
//  Evim
//
//  Created by Burak on 2025/10/03.
//

import SwiftUI
import SwiftData
import Supabase
import GoogleSignIn

@main
struct EvimApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var productStore = ProductStore()
    @State private var tagStore = TagStore()
    @State private var themeStore = ThemeStore()
    @State private var householdSettingsStore = HouseholdSettingsStore()
    @State private var authService = AuthService()
    @State private var bannerController = BannerController()

    var body: some Scene {
        WindowGroup {
            Group {
                if authService.isAuthenticated {
                    MainTabView()
                        .environment(productStore)
                        .environment(tagStore)
                        .environment(themeStore)
                        .environment(householdSettingsStore)
                        .bannerHost(bannerController)
                        .task { await householdSettingsStore.load() }
                } else {
                    LoginView()
                        .bannerHost(bannerController)
                }
            }
            .onOpenURL { url in
                // Let GoogleSignIn handle its callback URLs first
                if GoogleSignIn.GIDSignIn.sharedInstance.handle(url) { return }
                // Then forward any Supabase callbacks (e.g., web OAuth if used)
                authService.handleRedirectURL(url)
            }
            // Prompt for missing display name after first sign-in
            .sheet(isPresented: Binding(get: { authService.needsNamePrompt }, set: { authService.needsNamePrompt = $0 })) {
                NamePromptView()
            }
            .environment(authService)
            .environment(bannerController)
        }
    }
}
