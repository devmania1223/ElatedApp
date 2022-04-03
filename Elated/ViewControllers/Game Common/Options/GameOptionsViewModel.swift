//
//  GameOptionsViewModel.swift
//  Elated
//
//  Created by Marlon on 5/18/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Moya
import RxCocoa
import RxSwift
import SwiftyJSON

class GameOptionsViewModel: BaseViewModel {
    
    let selectedItem = BehaviorRelay<Int>(value: 0)
    let options = BehaviorRelay<[GameOption]>(value: [])
    let gameCreated = PublishRelay<SparkFlirtNewGameInfo?>()

    enum GameSelection: Int {
        case storyShare
        case basho
        case emojiGo
        
        func getTitle() -> String {
            switch self {
            case .storyShare:
                return Game.storyshare.rawValue
            case .basho:
                return Game.basho.rawValue
            case .emojiGo:
                return Game.emojigo.rawValue
            }
        }
    }
    
    struct GameOption {
        
        var image: UIImage?
        var background: UIImage?
        var logo: UIImage?
        var message: String = ""

        init(image: UIImage, background: UIImage?, logo: UIImage, message: String) {
            self.image = image
            self.background = background
            self.logo = logo
            self.message = message
        }
        
    }
    
    override init() {
        super.init()
        
        let options = [GameOption(image: #imageLiteral(resourceName: "asset-storyshare-typewriter-menu"), background: #imageLiteral(resourceName: "background-storyshare"), logo: #imageLiteral(resourceName: "logo-storyshare-text"), message: "sparkFlirt.game.options.storyShare".localized),
                       GameOption(image: #imageLiteral(resourceName: "Basho BG"), background: nil, logo: #imageLiteral(resourceName: "logo-basho"), message: "sparkFlirt.game.options.basho".localized),
                       GameOption(image: #imageLiteral(resourceName: "emojiGoBackground"), background: nil, logo: #imageLiteral(resourceName: "graphic-emojiGo"), message: "sparkFlirt.game.options.emojiGo".localized)]
        self.options.accept(options)
        
    }
    
    func startGame(inviteId: Int) {
        guard let selectedGame = GameSelection(rawValue: selectedItem.value) else { return }
        print("SparkFlirt - StartGame: \(selectedGame.getTitle()) - inviteId - \(inviteId)")
        self.manageActivityIndicator.accept(true)

        ApiProvider.shared.request(SparkFlirtService.startSparkFlirtGame(id: inviteId, game: selectedGame.getTitle()))
            .subscribe(onSuccess: { [weak self] res in
                print(JSON(res))
                self?.manageActivityIndicator.accept(false)
                let response = SparkFlirtNewGameResponse(JSON(res))
                self?.gameCreated.accept(response.data)
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            #if DEBUG
            print(err)
            #endif
            if let code = BasicResponse(json).code {
                let message = LanguageManager.shared.errorMessage(for: code)
                //present alert triggers binding on the view controller, make sure its handled
                self?.presentAlert.accept(("", message))
            }
        }).disposed(by: self.disposeBag)
    }

}
