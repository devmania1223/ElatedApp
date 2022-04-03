//
//  LandingViewController+Gmail.swift
//  Elated
//
//  Created by Marlon on 5/11/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

//old code
//extension LandingViewController: GIDSignInDelegate {
//
//    func sign(_ signIn: GIDSignIn!,
//              didSignInFor user: GIDGoogleUser!,
//              withError error: Error!) {
//
//        self.manageActivityIndicator.accept(true)
//        if let error = error {
//            self.manageActivityIndicator.accept(false)
//            self.presentAlert(title: "", message: error.localizedDescription)
//           return
//        }
//
//        let authentication = user.authentication
//        guard let userID = user.userID else { return }
//        self.viewModel.signupGoogle(token: authentication.accessToken, id: userID)
//    }
//
//}

