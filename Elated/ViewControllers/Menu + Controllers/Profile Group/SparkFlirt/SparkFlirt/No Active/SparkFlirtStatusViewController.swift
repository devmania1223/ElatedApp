//
//  SparkFlirtStatusViewController.swift
//  Elated
//
//  Created by Marlon on 2021/3/5.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Lottie
import iCarousel

class SparkFlirtStatusViewController: ScrollViewController {

    let viewModel = SparkFlirtSettingsBalanceViewModel()
    
    internal let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "profile.sparkFlirt.purchase.title".localized;
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .futuraMedium(22)
        return label
    }()
    
    private let animationView: AnimationView = {
        let animation = AnimationView(name: "spark-logo")
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.backgroundBehavior = .pauseAndRestore
        animation.play()
        return animation
    }()
    
    internal lazy var carousel: iCarousel = {
        let view = iCarousel(frame: .zero)
        view.type = .rotary
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private let purchaseButton = UIButton.createCommonBottomButton("profile.sparkFlirt.purchase".localized)
    private let inviteButton: UIButton = {
        let button = UIButton.createButtonWithShadow("profile.sparkFlirt.invite".localized, with: true)
        button.borderWidth = 0.25
        button.borderColor = .silver
        return button
    }()
    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNavigationBar(.white,
                                tintColor: .elatedPrimaryPurple,
                                addBackButton: true)
        IAPManager.shared.purchaseCompleteHandler = { [weak self] productId in
            guard let self = self else { return }
            guard let credit = IAPManager.Product(rawValue: productId)?.credits else {
                // Refresh the credits and purchase list
                self.viewModel.getSparkFlirtAvailableCredit()
                return
            }
            // Show credit successful screen.
            let vc = SparkFlirtAddCreditSuccessViewController(.viaInAppPurchase, credit: credit)
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
        carousel.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.setupNavigationBar(.white,
                                font: .futuraMedium(20),
                                tintColor: .white,
                                backgroundImage: #imageLiteral(resourceName: "background-header"))
        IAPManager.shared.purchaseCompleteHandler = nil
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(50)
            make.top.equalToSuperview()
        }
        
        contentView.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(-40)
            make.width.height.equalTo(250)
        }
        
        contentView.addSubview(carousel)
        carousel.snp.makeConstraints { make in
            make.top.equalTo(animationView.snp.bottom).offset(-30)
            make.height.equalTo(141)
            make.left.right.equalToSuperview()
        }
        
        contentView.addSubview(purchaseButton)
        purchaseButton.snp.makeConstraints { make in
            make.top.equalTo(carousel.snp.bottom).offset(20)
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(63)
        }
        
        contentView.addSubview(inviteButton)
        inviteButton.snp.makeConstraints { make in
            make.top.equalTo(purchaseButton.snp.bottom).offset(15)
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(63)
            make.bottom.equalToSuperview().offset(-25)
        }
        
        view.addSubview(bottomBackground)
        bottomBackground.snp.makeConstraints { make in
            make.height.equalTo(135)
            make.left.equalToSuperview().offset(-2)
            make.right.equalToSuperview().offset(2)
            make.bottom.equalToSuperview().offset(Util.heigherThanIphone6 ? 2 : 100)
        }
        view.bringSubviewToFront(scrollView)
        
        centerContentViewIfNeeded(offset: Util.heigherThanIphone6 ? 133 : 35)
    }
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        IAPManager.shared.viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        viewModel.selectedPurchaseItem.subscribe(onNext: { [weak self] item in
            self?.carousel.reloadData()
        }).disposed(by: disposeBag)
        
        purchaseButton.rx.tap.bind { [weak self] _ in
            guard let self = self,
                  !IAPManager.shared.products.isEmpty
            else { return }
            let index = self.viewModel.selectedPurchaseItem.value
            let productId = IAPManager.shared.products[index].productIdentifier
            IAPManager.shared.purchase(product: productId)
        }.disposed(by: disposeBag)

    }

}

extension SparkFlirtStatusViewController: iCarouselDataSource {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return IAPManager.shared.products.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let cell = PriceCarouselCellView()
        let price = IAPManager.shared.products[index].localizedPrice ?? ""
        let title = IAPManager.shared.products[index].localizedTitle
        cell.set(selected: viewModel.selectedPurchaseItem.value == index,
                 price: price,
                 amount: title)
        return cell
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing {
            return value * 2
        }
        return value
    }
    
}

extension SparkFlirtStatusViewController: iCarouselDelegate {
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        viewModel.selectedPurchaseItem.accept(index)
    }
}
