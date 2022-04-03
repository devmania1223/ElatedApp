//
//  GameOptionsViewController.swift
//  Elated
//
//  Created by Marlon on 5/17/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import iCarousel

class GameOptionsViewController: BaseViewController {

    private let viewModel = GameOptionsViewModel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "sparkFlirt.game.options.message".localized
        label.font = .futuraMedium(12)
        label.textColor = .jet
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let p1ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "h7")
        return imageView
    }()
    
    private let p1NameLabel: UILabel = {
        let label = UILabel()
        label.font = .futuraMedium(12)
        label.textColor = .jet
        return label
    }()
    
    private let p2ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.cornerRadius = 25
        imageView.image = #imageLiteral(resourceName: "odu2")
        return imageView
    }()
    
    private let p2NameLabel: UILabel = {
        let label = UILabel()
        label.font = .futuraMedium(12)
        label.textColor = .jet
        return label
    }()
    
    private let p1Label: UILabel = {
        let label = UILabel()
        label.text = "sparkFlirt.game.player.1".localized
        label.font = .futuraBook(12)
        label.textColor = .jet
        return label
    }()
    
    private let p2Label: UILabel = {
        let label = UILabel()
        label.text = "sparkFlirt.game.player.2".localized
        label.font = .futuraBook(12)
        label.textColor = .jet
        return label
    }()
    
    private lazy var carousel: iCarousel = {
        let view = iCarousel(frame: .zero)
        view.type = .linear
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "page-right"), for: .normal)
        return button
    }()
    
    private let leftButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "page-left"), for: .normal)
        return button
    }()
    
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = 3
        control.currentPage = 0
        control.pageIndicatorTintColor = .lavanderFloral
        control.currentPageIndicatorTintColor = .elatedPrimaryPurple
        control.isUserInteractionEnabled = false
        return control
    }()
    
    private let selectButton = UIButton.createCommonBottomButton("common.select")
    private let tutorialButton: UIButton = {
        let button = UIButton.createButtonWithShadow("common.showTutorial", with: true)
        button.borderWidth = 0.25
        button.borderColor = .silver
        return button
    }()
    
    private let cellSize: CGFloat = Util.heigherThanIphone6 ? 300.0 : 226.0
    private var inviteId: Int?

    init(_ inviteId: Int, playWith: MatchWith) {
        super.init(nibName: nil, bundle: nil)
        self.inviteId = inviteId
        p1NameLabel.text = MemCached.shared.userInfo?.getDisplayName()
        p2NameLabel.text = playWith.getDisplayName()
        p1ImageView.kf.setImage(with: URL(string: MemCached.shared.userInfo?.profileImages.first?.image ?? ""), placeholder: #imageLiteral(resourceName: "profile-placeholder"))
        p2ImageView.kf.setImage(with: URL(string: playWith.images.first?.image ?? ""), placeholder: #imageLiteral(resourceName: "profile-placeholder"))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carousel.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "sparkFlirt.game.options.title".localized
        self.navigationController?.hideNavBar(false)
        self.setupNavigationBar(.white,
                                font: .futuraMedium(20),
                                tintColor: .white,
                                backgroundImage: #imageLiteral(resourceName: "background-header"),
                                addBackButton: true)
    }

    override func initSubviews() {
        super.initSubviews()
        
        // Top section
        let purpleView = UIView()
        purpleView.backgroundColor = .palePurplePantone
        view.addSubview(purpleView)
        purpleView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        purpleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.right.equalToSuperview().inset(33)
        }
        
        p1ImageView.snp.makeConstraints { make in
            make.height.width.equalTo(50)
        }
        
        p2ImageView.snp.makeConstraints { make in
            make.height.width.equalTo(50)
        }
        
        let p1LabelStack = UIStackView(arrangedSubviews: [p1NameLabel, p1Label])
        p1LabelStack.spacing = 6
        p1LabelStack.axis = .vertical

        let p2LabelStack = UIStackView(arrangedSubviews: [p2NameLabel, p2Label])
        p2LabelStack.spacing = 6
        p2LabelStack.axis = .vertical
        
        let p1Stack = UIStackView(arrangedSubviews: [p1ImageView, p1LabelStack])
        p1Stack.spacing = 6
        
        let p2Stack = UIStackView(arrangedSubviews: [p2ImageView, p2LabelStack])
        p2Stack.spacing = 6
        
        let playerStack = UIStackView(arrangedSubviews: [p1Stack, p2Stack])
        playerStack.spacing = 25
        
        purpleView.addSubview(playerStack)
        playerStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.centerX.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(15)
        }
        
        // Bottom section
        let bStack = UIStackView(arrangedSubviews: [tutorialButton, selectButton])
        bStack.distribution = .fillEqually
        bStack.spacing = 6
        view.addSubview(bStack)
        bStack.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(bStack.snp.top)
        }
        
        // Mid section
        view.addSubview(carousel)
        carousel.snp.makeConstraints { make in
            make.top.equalTo(purpleView.snp.bottom).offset(15)
            make.height.greaterThanOrEqualTo(cellSize)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.top)
        }

        view.addSubview(leftButton)
        leftButton.snp.makeConstraints { make in
            make.centerY.equalTo(carousel)
            make.height.width.equalTo(36)
            make.centerX.equalTo(carousel.snp.left).inset(36)
        }

        view.addSubview(rightButton)
        rightButton.snp.makeConstraints { make in
            make.centerY.equalTo(carousel)
            make.height.width.equalTo(36)
            make.centerX.equalTo(carousel.snp.right).inset(36)
        }
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.selectedItem.bind(to: pageControl.rx.currentPage).disposed(by: disposeBag)
        
        leftButton.rx.tap.bind { [weak self] in
            guard let selected = self?.viewModel.selectedItem.value else { return }
            let index = selected - 1 >= 0 ? selected - 1 : 0
            self?.carousel.scrollToItem(at: index, animated: true)
        }.disposed(by: disposeBag)
        
        rightButton.rx.tap.bind { [weak self] in
            guard let selected = self?.viewModel.selectedItem.value else { return }
            let index = selected + 1 <= 2 ? selected + 1 : 2
            self?.carousel.scrollToItem(at: index, animated: true)
        }.disposed(by: disposeBag)
        
        tutorialButton.rx.tap.bind { [weak self] in
            guard let self = self,
                  let selectedGame = GameOptionsViewModel.GameSelection(rawValue: self.viewModel.selectedItem.value)
            else { return }
            print(selectedGame)
            switch selectedGame {
            case .basho:
                let vc = BashoTutorialIntroViewController()
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: nil)
            case .emojiGo:
                let vc = EmojiGoTutorialIntroViewController()
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: nil)
            case .storyShare:
                let vc = StoryShareTutorialIntroViewController()
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: nil)
                break
            }
        }.disposed(by: disposeBag)
        
        selectButton.rx.tap.bind { [weak self] in
            guard let self = self,
                  let inviteId = self.inviteId
            else { return }
            
            self.viewModel.startGame(inviteId: inviteId)
        }.disposed(by: disposeBag)
        
        viewModel.gameCreated.subscribe(onNext: { [weak self] info in
            guard let self = self,
                let gameID = info?.id,
                  let game = info?.gameTitle
            else { return }
            
            // TODO: optimize code once storyshare is implemented
            switch game {
            case .basho:
                let vc = BashoLoadingViewController(gameID)
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: nil)
            case .emojigo:
                let vc = EmojiGoLoadingViewController(gameID)
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: nil)
            case .storyshare:
                let vc = StoryShareLoadingViewController(gameID)
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: nil)
                break
            }
        }).disposed(by: disposeBag)
        
    }
 
}

extension GameOptionsViewController: iCarouselDataSource {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return viewModel.options.value.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let cell = GameOptionsCaroucelCell(size: cellSize)
        cell.set(viewModel.options.value[index])
        return cell
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing {
            return value * 1.05
        }
        return value
    }
    
}

extension GameOptionsViewController: iCarouselDelegate {
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        viewModel.selectedItem.accept(index)
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        let index = carousel.index(ofItemView: carousel.currentItemView ?? UIView())
        viewModel.selectedItem.accept(index)
    }
}
