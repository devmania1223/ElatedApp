//
//  ApiProvider.swift
//  Elated
//
//  Created by Marlon on 2021/2/20.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON

enum ApiCodeResponse: Int {
    case fail = -1
    case success = 1
    case tokenExpired = 10001
    case emailDoesNotExists = 1005
}

final public class ApiProvider {
    
    public static let shared = ApiProvider()
    private init() {}
    private let provider = MoyaProvider<MultiTarget>()
    
    func request<Request: TargetType>(_ request: Request) -> Single<Any> {
        let target = MultiTarget.init(request)
        //print("ENDPOINT: \(request.baseURL)\(request.path)") // DBG purpose only
        //print("PARAMETERS: \(request.task)") // DBG purpose only
        return provider.rx.request(target)
            .flatMap { res in
                //print("RESPONSE: \(try res.mapString())") // DBG purpose only
                if 200 ... 299 ~= res.statusCode {
                    let result = BasicResponse(try JSON(res.mapJSON()))
                    if let code = result.code, code != ApiCodeResponse.success.rawValue {
                        if ApiCodeResponse(rawValue: code) == ApiCodeResponse.tokenExpired {
                            //Token expired Push notif from here
                            NotificationCenter.default.post(Notification(name: .userLogout))
                            UserDefaults.standard.clearUserData()
                        }
                        return Single.error(MoyaError.jsonMapping(res))
                    } else if result.success == false {
                        return Single.error(MoyaError.jsonMapping(res))
                    }
                }
                return Single.just(res)
            }
            .filterSuccessfulStatusCodes()
            .mapJSON(failsOnEmptyData: false)
    }
    
    //for non Elated calls
    func requestExternal<Request: TargetType>(_ request: Request) -> Single<Any> {
        let target = MultiTarget.init(request)
        return provider.rx.request(target)
            .filterSuccessfulStatusCodes()
            .mapJSON(failsOnEmptyData: false)
    }
    
    //for multiple or nested calls
    func observe<Request: TargetType>(_ request: Request) -> Observable<Event<Any>> {
        let target = MultiTarget.init(request)
        return self.request(target)
            .flatMap { res in
                if JSON(res) != JSON.null {
                    let result = BasicResponse(JSON(res))
                    if let code = result.code, code != ApiCodeResponse.success.rawValue {
                        if ApiCodeResponse(rawValue: code) == ApiCodeResponse.tokenExpired {
                            //Token expired Push notif from here
                            NotificationCenter.default.post(Notification(name: .userLogout))
                            UserDefaults.standard.clearUserData()
                        }
                        return Single.error(MoyaError.jsonMapping(Response(statusCode: 200, data: try JSON(res).rawData())))
                    } else if result.success == false {
                        return Single.error(MoyaError.jsonMapping(Response(statusCode: 200, data: try JSON(res).rawData())))
                    }
                }
                return Single.just(res)
            }
            .asObservable()
            .materialize()
    }
}
