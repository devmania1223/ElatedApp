//
//  MatchesViewController.swift
//  Elated
//
//  Created by Marlon on 2021/3/5.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import iCarousel
import RxSwift

class MatchesListViewController: BaseViewController {
    
    let accountsViewModel = SparkFlirtSettingsBalanceViewModel()
    let viewModel = MatchesListViewModel()
    
    internal lazy var carousel: iCarousel = {
        let view = iCarousel(frame: .zero)
        view.type = .rotary
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    init(_ type: MatchType) {
        self.viewModel.type.accept(type)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getMatches()
        accountsViewModel.getSparkFlirtAvailableCredit()
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.addSubview(carousel)
        carousel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(85)
            make.height.equalTo(368)
            make.left.right.equalToSuperview()
        }
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)

        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        Observable.combineLatest(viewModel.type,
                                 viewModel.selectedItem,
                                 viewModel.bestMatches,
                                 viewModel.recentMatches)
            .subscribe(onNext: { [weak self] _, _, _, _ in
            self?.carousel.reloadData()
        }).disposed(by: disposeBag)
        
    }
    
}

extension MatchesListViewController: iCarouselDataSource {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return viewModel.type.value == .best
            ? viewModel.bestMatches.value.count
            : viewModel.recentMatches.value.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let cell = MatchesCarouselViewCell()
        let matches = viewModel.type.value == .best
                ? viewModel.bestMatches.value
                : viewModel.recentMatches.value
        let match = matches[index]
        cell.set(selected: viewModel.selectedItem.value == index,
                 match: match)
        
        cell.sparkAction = { [weak self] in
            guard let self = self else { return }
            
            if self.accountsViewModel.availableCredits.value == 0 {
                let vc = SparkFlirtStatusViewController()
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: nil)
                return
            }
            
            let vc = SparkFlirtSendInviteViewController(userInfo: match)
            self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
        }
        
        cell.favoriteAction = { [weak self] in
            guard let userId = match.matchedWith?.userId else {
                return
            }
            self?.viewModel.setFavorite(userId)
        }
        
        cell.cancelAction = { [weak self] in
            self?.viewModel.deleteMatch(match)
        }
        
        cell.viewUserAction = { [weak self] in
            let vc = ProfilePageViewController("profile.view.main".localized, viewUserID: match.matchedWith?.userId)
            vc.hidesBottomBarWhenPushed = true
            self?.navigationController?.show(vc, sender: nil)
        }
        
        return cell
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing {
            return value * 0.8
        }
        return value
    }
    
}

extension MatchesListViewController: iCarouselDelegate {
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        viewModel.selectedItem.accept(index)
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        let index = carousel.index(ofItemView: carousel.currentItemView ?? UIView())
        viewModel.selectedItem.accept(index)
    }
}


