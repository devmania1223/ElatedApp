//
//  SparkFlirtSettingsHistoryViewController.swift
//  Elated
//
//  Created by Marlon on 2021/3/9.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

//NOTE: This screen should show game history and not purchase history
class SparkFlirtSettingsHistoryViewController: BaseViewController {
    
    private let viewModel = SparkFlirtGameHistoryViewModel()
    private let tableView = SparkFlirtGameHistoryTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getGames()
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.left.right.bottom.equalToSuperview()
        }
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe(onNext: { [weak self] args in
          let (title, message) = args
          self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)

        viewModel.games.bind(to: tableView.data).disposed(by: disposeBag)
        
        tableView.didSelect.subscribe(onNext: { [weak self] game in
            //TODO: to be redo once EA-404 is done
            switch game.game {
            case .basho:
                let vc = BashoLoadingViewController(game.detail?.id ?? 0, fallbackViewController: SparkFlirtPageSettingsViewController.self)
                vc.hidesBottomBarWhenPushed = true
                self?.show(vc, sender: nil)
                break
            case .emojigo:
                let vc = EmojiGoLoadingViewController(game.detail?.id ?? 0, fallbackViewController: SparkFlirtPageSettingsViewController.self)
                vc.hidesBottomBarWhenPushed = true
                self?.show(vc, sender: nil)
                break
            case .storyshare:
                //TODO: implemente storyshare
                let vc = StoryShareLoadingViewController(game.detail?.id ?? 0)
                vc.hidesBottomBarWhenPushed = true
                self?.show(vc, sender: nil)
                break
            default:
                break
            }
        }).disposed(by: disposeBag)
        
        tableView.didSelectProfile.subscribe(onNext: { [weak self] userId in
            guard let self = self else { return }
            let vc = ProfilePageViewController("profile.view.main".localized, viewUserID: userId)
            self.navigationController?.show(vc, sender: nil)
        }).disposed(by: disposeBag)
    }

}
