//
//  LandingViewController+Apple.swift
//  Elated
//
//  Created by Marlon on 5/11/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import AuthenticationServices

extension LandingViewController: ASAuthorizationControllerDelegate {
    
    func appleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let appleId = credential.user
            if let dataToken = credential.identityToken,
               let dataCode = credential.authorizationCode,
               let token = String(data: dataToken, encoding: .utf8),
               let code = String(data: dataCode, encoding: .utf8) {
                self.viewModel.signupApple(token: token,
                                           code: code,
                                           user: appleId,
                                           fname: credential.fullName?.givenName,
                                           lname: credential.fullName?.familyName)
            }
        }

    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}

extension LandingViewController: ASAuthorizationControllerPresentationContextProviding {
    //For present window

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {

        return self.view.window!

    }

}

