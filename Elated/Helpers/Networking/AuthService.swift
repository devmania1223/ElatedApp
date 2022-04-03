//
//  AuthService.swift
//  Elated
//
//  Created by Marlon on 2021/2/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//


import Foundation
import Moya

enum AuthService { //TODO: Rename to AuthService after deletion of the existing one
    
    case signup(email: String, password: String)
    case login(username: String, password: String)
    case convertToken
    case disconnetBackend
    case invalidateSessions
    case token
    case revokeToken
    case logout
    case getUsers(page: Int)
    case activateUser(uid: String, token: String)
    case getMe
    case updateFullMe(email: String)
    case updatePartialMe(email: String)
    case deleteMe
    case resentActivation(email: String)
    case resetPassword(email: String)
    case resetPasswordConfirm(uid: String, token: String, newPassword: String)
    case resetUsername(email: String)
    case resetUsernameConfirm(newUsername: String)
    case setPassword(newPassword: String, currentPassword: String)
    case setUsername(newUsername: String)
    case getUser(id: String)
    case updateUserFull(id: String, email: String)
    case updateUserPartial(id: String, email: String)
    case deleteUser(id: String)
    case otpEmailVerify(code: String, email: String)
    case otpResendEmail(email: String)

}

extension AuthService: TargetType { //TODO: Rename to AuthService after deletion of the existing one
    var baseURL: URL {
        switch self {
        case .signup,
             .login,
             .otpResendEmail,
             .otpEmailVerify:
            return URL(string: Environment.rootURLString + "/api/v1")!
        default:
            return URL(string: Environment.rootURLString + "/auth/v1")!
        }
    }
    
    var path: String {
        //TODO: Remove the stupid "/" at the end after the API is fixed
        switch self {
        case .signup:
            return "/signup/"
        case .login:
            return "/login/"
        case .convertToken:
            return "/convert-token/"
        case .disconnetBackend:
            return "/disconnect-backend/"
        case .invalidateSessions:
            return "/invalidate-sessions/"
        case .token:
            return "/token/"
        case .revokeToken:
            return "/revoke-token/"
        case .logout:
            return "/logout/"
        case .getUsers:
            return "/users/"
        case .activateUser:
            return "/users/activation/"
        case .getMe,
             .updateFullMe,
             .updatePartialMe,
             .deleteMe:
            return "/users/me/"
        case .resentActivation:
            return "/users/resend_activation/"
        case .resetPassword:
            return "/users/auth/users/reset_password/"
        case .resetPasswordConfirm:
            return "/users/reset_password_confirm/"
        case .resetUsername:
            return "/users/reset_username/"
        case .resetUsernameConfirm:
            return "/users/reset_username_confirm/"
        case .setPassword:
            return "/users/set_password/"
        case .setUsername:
            return "/users/set_username/"
        case let .getUser(id),
             let .updateUserFull(id, _),
             let .updateUserPartial(id, _),
             let .deleteUser(id):
            return "/users/\(id)/"
        case .otpEmailVerify:
            return "/signup/verify_email_otp/"
        case .otpResendEmail:
            return "/signup/resend_email_otp/"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .signup,
             .login,
             .convertToken,
             .disconnetBackend,
             .invalidateSessions,
             .token,
             .revokeToken,
             .logout,
             .activateUser,
             .resentActivation,
             .resetPassword,
             .resetPasswordConfirm,
             .resetUsername,
             .resetUsernameConfirm,
             .setPassword,
             .setUsername:
            return .post
        case .getUsers,
             .getMe,
             .getUser:
            return .get
        case .updateFullMe,
             .updateUserFull,
             .otpResendEmail,
             .otpEmailVerify:
            return .put
        case .updatePartialMe,
             .updateUserPartial:
            return .patch
        case .deleteMe,
             .deleteUser:
            return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .signup(email, password):
            return .requestParameters(parameters: ["email": email,
                                                   "username": email,
                                                   "password": password],
                                      encoding: JSONEncoding.default)
            
        case let .login(username, password):
            return .requestParameters(parameters: ["username": username,
                                                   "password": password],
                                      encoding: JSONEncoding.default)
        case .convertToken,
             .disconnetBackend,
             .invalidateSessions,
             .token,
             .revokeToken,
             .logout,
             .deleteMe,
             .getUser,
             .deleteUser,
             .getMe:
            return .requestPlain
        case let .getUsers(page):
            return .requestParameters(parameters: ["page": page],
                                      encoding: URLEncoding.default)
        case let .activateUser(uid, token):
            return .requestParameters(parameters: ["uid": uid,
                                                   "token": token],
                                      encoding: URLEncoding.default)
        case let .updateFullMe(email),
             let .updatePartialMe(email),
             let .resentActivation(email),
             let .resetPassword(email),
             let .resetUsername(email),
             let .updateUserFull(_, email),
             let .updateUserPartial(_, email):
            return .requestParameters(parameters: ["email": email], encoding: JSONEncoding.default)
        case let .resetPasswordConfirm(uid, token, newPassword):
            return .requestParameters(parameters: ["uid": uid,
                                                   "token": token,
                                                   "new_password": newPassword],
                                      encoding: JSONEncoding.default)
        case let .resetUsernameConfirm(newUsername),
             let .setUsername(newUsername):
            return .requestParameters(parameters: ["new_username": newUsername], encoding: JSONEncoding.default)
        case let .setPassword(newPassword, currentPassword):
            return .requestParameters(parameters: ["new_password": newPassword,
                                                   "current_password": currentPassword],
                                      encoding: JSONEncoding.default)
        case let .otpEmailVerify(code, email):
            return .requestParameters(parameters: ["code": code,
                                                   "email": email],
                                      encoding: JSONEncoding.default)
        case let .otpResendEmail(email):
            return .requestParameters(parameters: ["email": email],
                                      encoding: JSONEncoding.default)
        }
        
    }
    
    var headers: [String : String]? {
        switch self {
        case .login,
             .signup,
             .otpEmailVerify,
             .otpResendEmail:
            return nil
        default:
            return NetworkManager.commonHeaders
        }
    }
    
}
