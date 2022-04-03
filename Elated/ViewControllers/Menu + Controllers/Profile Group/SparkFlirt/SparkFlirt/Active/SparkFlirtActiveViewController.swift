//
//  SparkFlirtActiveViewController.swift
//  Elated
//
//  Created by Marlon on 5/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class SparkFlirtActiveViewController: BaseViewController {
    
    let accountsViewModel = SparkFlirtSettingsBalanceViewModel()
    let viewModel = SparkFlirtActiveViewModel()
    
    private let balanceView: UIView = {
        let view = UIView()
        view.backgroundColor = .palePurplePantone
        return view
    }()

    let balanceLabel: UILabel = {
        let label = UILabel()
        label.text = "profile.sparkFlirt.balance".localized
        label.textColor = .jet
        label.font = .futuraMedium(16)
        return label
    }()
    
    let sparkImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "buttons-sparkflirtyellow-circle"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let remainingLabel: UILabel = {
        let label = UILabel()
        label.text = "profile.sparkFlirt.balance.remaining".localizedFormat("0")
        label.textColor = .elatedPrimaryPurple
        label.font = .futuraMedium(16)
        return label
    }()
    
    private lazy var creditStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [remainingLabel])
        view.spacing = 5
        return view
    }()
    
    let sparkButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "buttons-sparkflirtyellow-circle"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    private let purchaseButton = UIButton.createCommonBottomButton("profile.sparkFlirt.purchase".localized)
    
    let tableView = SparkFlirtGamesTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        accountsViewModel.getSparkFlirtAvailableCredit()
        viewModel.getGames()

    }
    
    override func initSubviews() {
        super.initSubviews()
       
        view.addSubview(balanceView)
        balanceView.snp.makeConstraints { make in
            make.top.equalTo(50)
            make.left.right.equalToSuperview().inset(10)
        }
        
        sparkImageView.snp.makeConstraints { make in
            make.width.height.equalTo(23)
        }
        
        let stack = UIStackView(arrangedSubviews: [balanceLabel, creditStackView])
        stack.spacing = 12
        stack.axis = .vertical
        balanceView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(18)
        }
        
        balanceView.addSubview(sparkButton)
        sparkButton.snp.makeConstraints { make in
            make.height.width.equalTo(60)
            make.right.equalToSuperview().inset(10)
            make.centerY.equalTo(stack)
        }
        
        balanceView.addSubview(purchaseButton)
        purchaseButton.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(50)
            make.right.equalToSuperview().inset(10)
            make.centerY.equalTo(stack)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(balanceView.snp.bottom)
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
        
        accountsViewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        accountsViewModel.availableCredits.bind { [weak self] credits in
            guard let self = self else { return }
            self.remainingLabel.text = "profile.sparkFlirt.balance.remaining".localizedFormat("\(credits)")
            self.remainingLabel.textColor = credits > 0 ? .elatedPrimaryPurple : .danger
            self.sparkButton.isHidden = credits > 0 ? false : true
            self.purchaseButton.isHidden = credits > 0 ? true : false
            self.sparkImageView.isHidden = credits > 0 ? true : false
            if credits > 0 {
                self.creditStackView.removeArrangedSubview(self.sparkImageView)
            } else {
                self.creditStackView.insertArrangedSubview(self.sparkImageView, at: 0)
            }
        }.disposed(by: disposeBag)
        
        sparkButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let vc = SparkFlirtStatusViewController()
            vc.hidesBottomBarWhenPushed = true
            self.show(vc, sender: nil)
        }.disposed(by: disposeBag)
        
        purchaseButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let vc = SparkFlirtStatusViewController()
            vc.hidesBottomBarWhenPushed = true
            self.show(vc, sender: nil)
        }.disposed(by: disposeBag)
        
        tableView.didNudge.subscribe(onNext: { [weak self] game in
            guard let self = self else { return }
            self.viewModel.sendGameNudge(gameData: game)
        }).disposed(by: disposeBag)
        
        tableView.didPlay.subscribe(onNext: { [weak self] game in
            self?.play(game: game)
        }).disposed(by: disposeBag)
        
        tableView.didSelect.subscribe(onNext: { [weak self] game in
            self?.play(game: game)
        }).disposed(by: disposeBag)
        
    }

    override func prepareTooltips() {
        TooltipManager.shared.reInit()
        let tip = TooltipInfo(tipId: .sparkFlirtAddMoreCredits,
                              direction: .autoVertical,
                              parentView: self.view,
                              maxWidth: 100,
                              inView: balanceView,
                              fromRect: !sparkButton.isHidden ? sparkButton.frame : purchaseButton.frame,
                              offset: 0,
                              duration: 2.0)
        TooltipManager.shared.addTip(tip)
        TooltipManager.shared.showIfNeeded()
    }
    
    private func play(game: GameDetail) {
        DispatchQueue.main.async {
            let otherUser = MemCached.shared.isSelf(id: game.invitedUser?.id)
            ? game.invitedUser?.userID
            : game.hostUser?.userID
            
            guard let otherId = otherUser,
                    let gameId = game.detail?.id else {
                self.presentAlert(title: "", message: "sparkFlirt.invalid.game.data".localized)
                return
            }
            
            switch game.game {
            case .basho:
                let vc = BashoLoadingViewController(gameId)
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: nil)
                break
            case .emojigo:
                let vc = EmojiGoLoadingViewController(gameId)
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: nil)
                break
            case .storyshare:
                let vc = StoryShareLoadingViewController(gameId)
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: nil)
                break
            default:
                break
            }
        }
    }
    
}
