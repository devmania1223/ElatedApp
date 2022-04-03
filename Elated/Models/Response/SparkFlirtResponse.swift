//
//  SparkFlirtResponse.swift
//  Elated
//
//  Created by Rey Felipe on 7/5/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SparkFlirtCreditsResponse: BaseResponse {
    
    var msg: String?

    var time: Int?
    
    var code: Int?
    
    var success: Bool?
    
    var credits: Int = 0
    
    init(_ json: JSON) {
        baseInit(json)
        credits = json["data"]["available_sparkflirts"].intValue
    }
    
}

struct SparkFlirtResponse: BaseResponse {
    
    var msg: String?

    var time: Int?
    
    var code: Int?
    
    var success: Bool?
    
    var data = [SparkFlirtInfo]()
    
    init(_ json: JSON) {
        baseInit(json)
        data = json["data"].arrayValue.map { SparkFlirtInfo($0) }
    }
    
}

struct SparkFlirtGamesResponse: BaseResponse {
    
    var msg: String?

    var time: Int?
    
    var code: Int?
    
    var success: Bool?
    
    var data = [SparkFlirtGameData]()
    
    init(_ json: JSON) {
        baseInit(json)
        data = json["data"].arrayValue.map { SparkFlirtGameData($0) }
    }
    
}

struct SparkFlirtNewGameResponse: BaseResponse {
    
    var msg: String?

    var time: Int?
    
    var code: Int?
    
    var success: Bool?
    
    var data: SparkFlirtNewGameInfo?
    
    init(_ json: JSON) {
        baseInit(json)
        data = SparkFlirtNewGameInfo(json["data"])
    }
    
}

struct SparkFlirtPurchaseHistoryResponse: BaseResponse, Pagination {
    
    var count: Int = 0
    
    var next: Int?
    
    var previous: Int?
    
    var total_pages: Int = 0
    
    var msg: String?

    var time: Int?
    
    var code: Int?
    
    var success: Bool?
    
    var data = [SparkFlirtPurchaseData]()
    
    init(_ json: JSON) {
        baseInit(json)
        pageInit(json["pagination"])
        data = json["data"].arrayValue.map { SparkFlirtPurchaseData($0) }
    }
    
}

struct SpartFlirtDetailResponse: BaseResponse {
    
    var msg: String?

    var time: Int?
    
    var code: Int?
    
    var success: Bool?
            
    var data: SparkFlirtDetail?
    
    init(_ json: JSON) {
        baseInit(json)
        data = SparkFlirtDetail(json["data"])
    }
}
