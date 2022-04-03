//
//  UserService.swift
//  Elated
//
//  Created by John Lester Celis on 3/16/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import Moya

enum UserServices {
    
    case completeProfile(id: Int)
    case createSocialFBDeauthenticate(requestFrom: String,
                                      status: String,
                                      user: Int)
    case deleteProfileImage(id: Int)
    case getSocialFBDeauthenticate(page: Int)
    case getUsers(page: Int)
    case getUsersByPath(id: Int)
    case getUsersMe
    case updateProfileCaption(id: Int, caption: String)
    case uploadProfilePicture(id: Int, image: UIImage, caption: String)
    case swapImagePositions(imageId: Int, newPosition: Int)
    case sendResetPasswordLink(email: String)
    case setPassword(uid: String, token: String, newPassword: String)
    case getUserInfos(ids: [Int])
    case firstTimeEvent(eventType: String)
    
}

extension UserServices: TargetType {
    
    var baseURL: URL {
        switch self {
        case .sendResetPasswordLink, .setPassword:
            return URL(string: Environment.rootURLString + "/api/v1/public/users")!
        default:
            return URL(string: Environment.rootURLString + "/api/v1/users")!
        }
    }
    
    var path: String {
        switch self {
        case .getUsers:
            return "/"
        case .getUsersMe:
            return "/me/"
        case let .completeProfile(id):
            return "/\(id)/profile_complete/"
        case .getSocialFBDeauthenticate,
             .createSocialFBDeauthenticate:
            return "/social/facebook/deauthenticate/"
        case let .getUsersByPath(id):
            return "/\(id)/"
        case .swapImagePositions(_, _):
            return "/profile/image/order/"
        case let .uploadProfilePicture(id, _, _):
            return "/\(id)/upload_profile_image/"
        case let .updateProfileCaption(id, _):
            return "/profile/image/\(id)/caption/"
        case let .deleteProfileImage(id):
            return "/profile/image/\(id)/"
        case .sendResetPasswordLink:
            return "/send_password_reset_link/"
        case .setPassword:
            return "/set_password/"
        case .getUserInfos:
            return "/chat/"
        case .firstTimeEvent:
            return "/first_time_events/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUsers,
             .getUsersMe,
             .getSocialFBDeauthenticate,
             .getUsersByPath,
             .getUserInfos:
            return .get
        case .completeProfile,
             .createSocialFBDeauthenticate,
             .uploadProfilePicture,
             .setPassword,
             .sendResetPasswordLink,
             .firstTimeEvent:
            return .post
        case .swapImagePositions,
             .updateProfileCaption:
             return .put
        case .deleteProfileImage:
            return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .swapImagePositions(imageId, newPosition):
            return .requestParameters(parameters: ["image_id": imageId,
                                                   "order": newPosition],
                                      encoding: JSONEncoding.default)
        case let .createSocialFBDeauthenticate(requestFrom, status, user):
            return .requestParameters(parameters: ["request_from": requestFrom,
                                                   "status": status,
                                                   "user": user],
                                      encoding: JSONEncoding.default)
        case let .getUsers(page),
             let .getSocialFBDeauthenticate(page):
            return .requestParameters(parameters: ["page": page],
                                     encoding: URLEncoding.default)
        case let .getUserInfos(ids):
            return .requestParameters(parameters: ["p": ids.map { "\($0)"}.joined(separator: ",")],
                                     encoding: URLEncoding.default)
        case .getUsersByPath,
             .getUsersMe,
             .deleteProfileImage,
             .completeProfile:
            return .requestPlain
        case let .uploadProfilePicture(_, image, caption):
            let captionData = caption.data(using: String.Encoding.utf8) ?? Data()
            var formData: [Moya.MultipartFormData] = [Moya.MultipartFormData(provider: .data(image.compressToData()),
                                                                             name: "image",
                                                                             fileName: String.randomFileName(),
                                                                             mimeType: "image/jpeg")]
            formData.append(Moya.MultipartFormData(provider: .data(captionData), name: "caption"))
            return .uploadMultipart(formData)
        case let .updateProfileCaption(_, caption):
            return .requestParameters(parameters: ["caption": caption],
                                      encoding: JSONEncoding.default)
        case let .sendResetPasswordLink(email):
            return .requestParameters(parameters: ["email": email],
                                      encoding: JSONEncoding.default)
        case let .setPassword(uid, token, newPassword):
            return .requestParameters(parameters: ["uid": uid,
                                                   "token": token,
                                                   "new_password": newPassword],
                                      encoding: JSONEncoding.default)
        case let .firstTimeEvent(eventType):
            return .requestParameters(parameters: ["event_type": eventType],
                                      encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return NetworkManager.commonHeaders
        }
    }

}
