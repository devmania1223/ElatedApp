//
//  SparkFlirtSettingsBalanceViewController.swift
//  Elated
//
//  Created by Marlon on 2021/3/9.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import iCarousel

class SparkFlirtSettingsBalanceViewController: ScrollViewController {

    let viewModel = SparkFlirtSettingsBalanceViewModel()
    
    let balanceLabel: UILabel = {
        let label = UILabel()
        label.text = "profile.sparkFlirt.balance".localized
        label.textColor = .jet
        label.font = .futuraMedium(16)
        return label
    }()
    
    let remainingLabel: UILabel = {
        let label = UILabel()
        label.text = "profile.sparkFlirt.balance.remaining".localizedFormat("0")
        label.textColor = .elatedPrimaryPurple
        label.font = .futuraMedium(16)
        return label
    }()
    
    let purchaseTitle: UILabel = {
        let label = UILabel()
        label.text = "profile.sparkFlirt.purchase".localized
        label.textColor = .jet
        label.font = .futuraMedium(16)
        label.textAlignment = .left
        return label
    }()
    
    let purchaseTotalLabel: UILabel = {
        let label = UILabel()
        label.text = "profile.sparkFlirt.total".localized
        label.textColor = .jet
        label.font = .futuraBook(14)
        label.textAlignment = .right
        return label
    }()
    
    let purchaseTotalValue: UILabel = {
        let label = UILabel()
        label.text = "0".localized
        label.textColor = .jet
        label.font = .futuraMedium(14)
        return label
    }()
    
    let sparkImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "buttons-sparkflirtyellow-circle"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    internal lazy var carousel: iCarousel = {
        let view = iCarousel(frame: .zero)
        view.type = .rotary
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    internal let purchaseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .elatedPrimaryPurple
        button.setTitleColor(.white, for: .normal)
        button.setTitle("profile.sparkFlirt.purchase".localized, for: .normal)
        button.titleLabel?.font = .futuraBook(14)
        button.cornerRadius = 25
        return button
    }()
    
    let purchaseHistoryLabel: UILabel = {
        let label = UILabel()
        label.text = "profile.sparkFlirt.purchase.history".localized
        label.textColor = .jet
        label.font = .futuraMedium(16)
        label.textAlignment = .left
        return label
    }()
    
    let seeAllButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitleColor(.elatedPrimaryPurple, for: .normal)
        button.setTitle("profile.sparkFlirt.see.all".localized, for: .normal)
        button.titleLabel?.font = .futuraBook(14)
        return button
    }()
    
    let purchaseHistoryTableView = SparkFlirtPurchaseHistoryTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "profile.sparkFlirt.purchase".localized
        self.setupNavigationBar(.white,
                                font: .futuraMedium(20),
                                tintColor: .white,
                                backgroundImage: #imageLiteral(resourceName: "background-header"),
                                addBackButton: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IAPManager.shared.purchaseCompleteHandler = { [weak self] productId in
            guard let self = self else { return }
            guard let credit = IAPManager.Product(rawValue: productId)?.credits else {
                // Refresh the credits and purchase list
                self.viewModel.getSparkFlirtAvailableCredit()
                self.viewModel.getSparkFlirtPurchaseHistory(initialPage: true)
                return
            }
            // Show credit successful screen.
            let vc = SparkFlirtAddCreditSuccessViewController(.viaInAppPurchase, credit: credit)
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
            
        }
        viewModel.getSparkFlirtAvailableCredit()
        viewModel.getSparkFlirtPurchaseHistory(initialPage: true)
        carousel.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IAPManager.shared.purchaseCompleteHandler = nil
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        let bgView = UIView()
        bgView.backgroundColor = .palePurplePantone
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.right.equalToSuperview().inset(10)
        }
        
        let balanceStack = UIStackView(arrangedSubviews: [sparkImageView, remainingLabel])
        balanceStack.spacing = 5
        sparkImageView.snp.makeConstraints { make in
            make.width.height.equalTo(23)
        }
        
        let balanceStack2 = UIStackView(arrangedSubviews: [balanceLabel, balanceStack])
        balanceStack2.spacing = 12
        balanceStack2.axis = .vertical
        bgView.addSubview(balanceStack2)
        balanceStack2.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(18)
        }
        
        contentView.addSubview(purchaseTitle)
        purchaseTitle.snp.makeConstraints { make in
            make.top.equalTo(bgView.snp.bottom).offset(35)
            make.left.equalToSuperview().inset(33)
        }
        
        contentView.addSubview(carousel)
        carousel.snp.makeConstraints { make in
            make.top.equalTo(purchaseTitle.snp.bottom).offset(35)
            make.height.equalTo(141)
            make.left.right.equalToSuperview()
        }
        
        contentView.addSubview(purchaseTotalLabel)
        purchaseTotalLabel.snp.makeConstraints { make in
            make.top.equalTo(carousel.snp.bottom).offset(35)
            make.left.equalToSuperview().offset(33)
        }
        
        contentView.addSubview(purchaseTotalValue)
        purchaseTotalValue.snp.makeConstraints { make in
            make.top.equalTo(purchaseTotalLabel)
            make.right.equalToSuperview().inset(33)
        }
        
        contentView.addSubview(purchaseButton)
        purchaseButton.snp.makeConstraints { make in
            make.top.equalTo(purchaseTotalLabel.snp.bottom).offset(35)
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(63)
        }
        
        contentView.addSubview(purchaseHistoryLabel)
        purchaseHistoryLabel.snp.makeConstraints { make in
            make.top.equalTo(purchaseButton.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(33)
        }
        
        contentView.addSubview(seeAllButton)
        seeAllButton.snp.makeConstraints { make in
            make.top.height.equalTo(purchaseHistoryLabel)
            make.right.equalToSuperview().inset(33)
        }
        
        contentView.addSubview(purchaseHistoryTableView)
        purchaseHistoryTableView.isUserInteractionEnabled = false
        purchaseHistoryTableView.snp.makeConstraints { make in
            make.top.equalTo(purchaseHistoryLabel.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(300)
        }
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.purchases.bind(to: purchaseHistoryTableView.data).disposed(by: disposeBag)
        
        IAPManager.shared.viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        viewModel.availableCredits.bind { [weak self] credits in
            guard let self = self else { return }
            self.remainingLabel.text = "profile.sparkFlirt.balance.remaining".localizedFormat("\(credits)")
            self.remainingLabel.textColor = credits > 0 ? .elatedPrimaryPurple : .danger
        }
        
        viewModel.selectedPurchaseItem.subscribe(onNext: { [weak self] item in
            guard let self = self,
                  !IAPManager.shared.products.isEmpty
            else { return }
            
            self.carousel.reloadData()
            self.purchaseTotalValue.text = IAPManager.shared.products[item].localizedPrice ?? ""
        }).disposed(by: disposeBag)
        
        purchaseButton.rx.tap.bind { [weak self] _ in
            guard let self = self,
                  !IAPManager.shared.products.isEmpty
            else { return }
            let index = self.viewModel.selectedPurchaseItem.value
            let productId = IAPManager.shared.products[index].productIdentifier
            IAPManager.shared.purchase(product: productId)
            
        }.disposed(by: disposeBag)
        
        seeAllButton.rx.tap.bind { [weak self] _ in
            guard let self = self else { return }
            let vc = SparkFlirtPurchaseHistoryViewController()
            self.show(vc, sender: nil)
        }.disposed(by: disposeBag)
        
    }

}

extension SparkFlirtSettingsBalanceViewController: iCarouselDataSource {
    
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

extension SparkFlirtSettingsBalanceViewController: iCarouselDelegate {
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        viewModel.selectedPurchaseItem.accept(index)
    }
}
