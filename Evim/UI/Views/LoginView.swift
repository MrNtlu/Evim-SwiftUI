//
//  LoginView.swift
//  Evim
//
//  Created by Burak on 2025/10/03.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @Environment(AuthService.self) private var auth
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Text("Evim")
                .font(.largeTitle).bold()
            Text("Sign in to continue")
                .foregroundStyle(.secondary)
            Spacer()

            Button {
                Task {
                    await signIn { try await auth.signInWithGoogleNative() }
                }
            } label: {
                HStack {
                    Image(systemName: "globe")
                    Text("Continue with Google")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            SignInWithAppleButton(.signIn, onRequest: { request in
                auth.startSignInWithApple(request)
            }, onCompletion: { result in
                Task {
                    await signIn {
                        try await auth.handleAppleSignIn(result)
                    }
                }
            })
            .frame(height: 44)

            if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.footnote)
            }

            if isLoading { ProgressView().padding(.top, 8) }

            Spacer()
        }
        .padding()
    }

    private func signIn(_ action: @escaping () async throws -> Void) async {
        errorMessage = nil
        isLoading = true
        do {
            try await action()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

#Preview {
    LoginView()
}
