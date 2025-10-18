//
//  HouseView.swift
//  Evim
//
//  Created by Burak on 2025/10/03.
//

import SwiftUI
import UIKit
import Combine
internal import Auth

struct HouseView: View {
    @State private var store = HouseholdStore()
    @State private var copied = false
    @State private var hasClipboardContent = false
    @FocusState private var focusedField: Field?

    private enum Field: Hashable { case joinCode, inviteEmail }
    @Environment(BannerController.self) private var banner
    @Environment(AuthService.self) private var authService

    var body: some View {
        NavigationStack {
            Form {
                if !store.invites.isEmpty {
                    Section("Invitations") {
                        ForEach(store.invites) { inv in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("You have been invited to a household")
                                    Text(inv.createdAt.formatted(date: .abbreviated, time: .shortened))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                HStack(spacing: 8) {
                                    if store.acceptingInviteId == inv.id {
                                        ProgressView().frame(width: 20, height: 20)
                                    } else {
                                        Button("Accept") { Task { await store.accept(invite: inv) } }
                                            .buttonStyle(.borderedProminent)
                                    }
                                    if store.decliningInviteId == inv.id {
                                        ProgressView().frame(width: 20, height: 20)
                                    } else {
                                        Button("Decline") { Task { await store.decline(invite: inv) } }
                                            .tint(.red)
                                            .buttonStyle(.bordered)
                                    }
                                }
                            }
                        }
                        Text("You can also join using the 8‑digit code.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Section("My Household") {
                    if store.isLoading {
                        ProgressView()
                    } else if let household = store.households.first {
                        HStack {
                            LabeledContent("Code", value: household.code)
                            Button {
                                UIPasteboard.general.string = household.code
                                copied = true
                            } label: { Image(systemName: "doc.on.doc") }
                            .buttonStyle(.plain)
                            .help("Copy code")
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Invite by email")
                            HStack {
                                TextField("name@example.com", text: $store.inviteEmail)
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.emailAddress)
                                    .focused($focusedField, equals: .inviteEmail)
                                    .onSubmit { Task { await store.invite(to: household.id) } }
                                if store.isInviting {
                                    ProgressView().frame(width: 20, height: 20)
                                } else {
                                    Button("Send") { Task { await store.invite(to: household.id) } }
                                        .disabled(store.inviteEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                                }
                            }
                            Text("Only household owner/admins can invite. Others will see an error.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.top, 4)
                    } else {
                        Text("No household found.")
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Join a Household") {
                    HStack {
                        HStack {
                            TextField("8-digit code", text: $store.joinCode)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.asciiCapable)
                                .focused($focusedField, equals: .joinCode)
                                .onSubmit { Task { await store.join() } }

                            if hasClipboardContent {
                                Button {
                                    if let clipboardText = UIPasteboard.general.string {
                                        store.joinCode = clipboardText
                                    }
                                } label: {
                                    Image(systemName: "doc.on.clipboard")
                                        .foregroundStyle(.secondary)
                                }
                                .buttonStyle(.plain)
                                .help("Paste from clipboard")
                            }
                        }

                        if store.isJoining {
                            ProgressView().frame(width: 20, height: 20)
                        } else {
                            Button("Join") { Task { await store.join() } }
                                .disabled(store.joinCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }

                    if let result = store.lastJoinResult {
                        Text(result == .joined ? "Joined successfully." : (result == .requested ? "Request sent for approval." : "You're already a member."))
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

                if let error = store.errorMessage {
                    Section {
                        Text(error).foregroundStyle(.red).font(.footnote)
                    }
                }
            }
            .navigationTitle("My Household")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if let household = store.households.first {
                        NavigationLink(destination: HouseholdAdminView(household: household)) {
                            Image(systemName: "person.3")
                        }
                    }
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                    }
                }

                ToolbarItem(placement: .principal) { EmptyView() } // iOS 18 fix
            }
            .keyboardDismissToolbar()
            .scrollDismissesKeyboard(.interactively)
            .task { await store.load(myEmail: authService.session?.user.email) }
            .onAppear { checkClipboard() }
            .onReceive(NotificationCenter.default.publisher(for: UIPasteboard.changedNotification)) { _ in
                checkClipboard()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                checkClipboard()
            }
            .onChange(of: store.errorMessage) { _, new in
                if let msg = new { banner.showError(msg) }
            }
            .onChange(of: store.lastJoinResult) { _, res in
                guard let res else { return }
                switch res {
                case .joined:
                    banner.show(BannerData(style: .success, message: "Joined household"))
                    Task { await store.load(myEmail: authService.session?.user.email) }
                case .requested:
                    banner.show(BannerData(style: .info, message: "Join request sent"))
                case .already_member:
                    banner.show(BannerData(style: .warning, message: "Already a member"))
                }
            }
            .onChange(of: store.inviteSuccess) { _, ok in
                if ok { banner.show(BannerData(style: .success, message: "Invite sent")); store.inviteSuccess = false }
            }
            .onChange(of: store.inviteActionSuccess) { _, ok in
                if ok {
                    banner.show(BannerData(style: .success, message: "Joined household"))
                    store.inviteActionSuccess = false
                    Task { await store.load(myEmail: authService.session?.user.email) }
                }
            }
            .onChange(of: store.invites) { _, _ in
                // no-op, placeholder if we need to react
            }
            .onChange(of: store.inviteDeclineSuccess) { _, ok in
                if ok {
                    banner.show(BannerData(style: .info, message: "Invitation declined"))
                    store.inviteDeclineSuccess = false
                    Task { await store.load(myEmail: authService.session?.user.email) }
                }
            }
            .alert("Copied", isPresented: $copied) {
                Button("OK", role: .cancel) { copied = false }
            } message: {
                Text("Household code copied to clipboard.")
            }
        }
    }

    private func checkClipboard() {
        hasClipboardContent = UIPasteboard.general.hasStrings
    }
}

#Preview {
    HouseView()
        .environment(ThemeStore())
}
