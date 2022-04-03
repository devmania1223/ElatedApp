//
//  SparkFlirtSettingsMenuViewController.swift
//  Elated
//
//  Created by Rey Felipe on 9/29/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class SparkFlirtSettingsMenuViewController: BaseViewController {
    
    enum MenuType: Int {
        case purchase
        case qr
        
        func getName() -> String {
            switch self {
            case .purchase:
                return "profile.sparkFlirt.purchase".localized
            case .qr:
                return "profile.sparkFlirt.scan.qr.code".localized
            }
        }
        
        func getImage() -> UIImage {
            switch self {
                case .purchase:
                    return #imageLiteral(resourceName: "icon-purchase")
                case .qr:
                    return #imageLiteral(resourceName: "icon-mobilephone")
            }
        }
        
    }

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
    
    let getSFLabel: UILabel = {
        let label = UILabel()
        label.text = "profile.sparkFlirt.get.sparkflirt".localized
        label.textColor = .jet
        label.font = .futuraMedium(16)
        label.textAlignment = .left
        return label
    }()
    
    let sparkImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "buttons-sparkflirtyellow-circle"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .white
        view.register(MenuItemTableViewCell.self,
                      forCellReuseIdentifier: MenuItemTableViewCell.identifier)
        view.separatorStyle = .none
        view.separatorColor = .clear
        view.estimatedRowHeight = 70
        view.rowHeight = UITableView.automaticDimension
        view.tableFooterView = UIView()
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getSparkFlirtAvailableCredit()
    }

    
    override func initSubviews() {
        super.initSubviews()
        
        let bgView = UIView()
        bgView.backgroundColor = .palePurplePantone
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.equalTo(50)
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
        
        view.addSubview(getSFLabel)
        getSFLabel.snp.makeConstraints { make in
            make.top.equalTo(bgView.snp.bottom).offset(35)
            make.left.equalToSuperview().inset(24)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(getSFLabel.snp.bottom).offset(25)
            make.left.right.bottom.equalToSuperview()
        }

    }
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        IAPManager.shared.viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        viewModel.availableCredits.bind { [weak self] credits in
            guard let self = self else { return }
            self.remainingLabel.text = "profile.sparkFlirt.balance.remaining".localizedFormat("\(credits)")
            self.remainingLabel.textColor = credits > 0 ? .elatedPrimaryPurple : .danger
        }
        
    }

}

extension SparkFlirtSettingsMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 //constant
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemTableViewCell.identifier)
            as? MenuItemTableViewCell ?? MenuItemTableViewCell()
        if let type = MenuType(rawValue: indexPath.row) {
            cell.set(image: type.getImage(), name: type.getName())
        }
        return cell
    }
}

extension SparkFlirtSettingsMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let type = MenuType(rawValue: indexPath.row) {
            switch type {
                case .purchase:
                    self.show(SparkFlirtSettingsBalanceViewController(), sender: nil)
                    return
                case .qr:
                    self.show(SparkFlirtScanQRCodeOptionsViewController(), sender: nil)
                    return
            }
        }
    }
    
}
