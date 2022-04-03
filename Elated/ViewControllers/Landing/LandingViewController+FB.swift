//
//  LandingViewController+FB.swift
//  Elated
//
//  Created by Marlon on 5/11/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

extension LandingViewController {
    
    func signUpWithFacebook() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["email", "public_profile"],
                           viewController: self) { [weak self] loginResult in
            switch loginResult {
            case let .success(_, _, result):
                self?.viewModel.signupFacebook(token: result.tokenString, id: result.userID)
                return
            case let .failed(error):
                self?.presentAlert(title: "common.error".localized,
                                   message: error.localizedDescription)
                return
            case .cancelled:
                return
            }
        }
    }
        
}
