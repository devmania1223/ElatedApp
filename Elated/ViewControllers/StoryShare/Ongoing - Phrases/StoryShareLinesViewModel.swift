//
//  StoryShareLinesViewModel.swift
//  Elated
//
//  Created by Marlon on 10/9/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
import Moya

class StoryShareLinesViewModel: BaseViewModel {

    let info = BehaviorRelay<StoryShareGameDetail?>(value: nil)
    
}
