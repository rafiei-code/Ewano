//
//  AppleSignIn.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/11/01.
//

import AuthenticationServices

/// Shows Apple's sign-in sheet and returns what the backend needs to verify the user.
@MainActor
final class AppleSignIn: NSObject {
    private var continuation: CheckedContinuation<AppleLoginRequest, Error>?
    private var controller: ASAuthorizationController?

    func signIn() async throws -> AppleLoginRequest {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        self.controller = controller
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            controller.performRequests()
        }
    }

    private func finish(_ result: Result<AppleLoginRequest, Error>) {
        continuation?.resume(with: result)
        continuation = nil
        controller = nil
    }
}

extension AppleSignIn: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    nonisolated func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityToken = credential.identityToken.flatMap({ String(data: $0, encoding: .utf8) }),
              let authorizationCode = credential.authorizationCode.flatMap({ String(data: $0, encoding: .utf8) })
        else {
            MainActor.assumeIsolated { finish(.failure(SocialSignInError.failed)) }
            return
        }
        let name = credential.fullName.map { PersonNameComponentsFormatter().string(from: $0) }
        let request = AppleLoginRequest(
            identityToken: identityToken,
            authorizationCode: authorizationCode,
            fullname: name?.isEmpty == false ? name : nil,
            email: credential.email
        )
        MainActor.assumeIsolated { finish(.success(request)) }
    }

    nonisolated func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let canceled = (error as? ASAuthorizationError)?.code == .canceled
        MainActor.assumeIsolated { finish(.failure(canceled ? SocialSignInError.canceled : SocialSignInError.failed)) }
    }

    nonisolated func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        MainActor.assumeIsolated { UIApplication.shared.keyWindow ?? ASPresentationAnchor() }
    }
}
