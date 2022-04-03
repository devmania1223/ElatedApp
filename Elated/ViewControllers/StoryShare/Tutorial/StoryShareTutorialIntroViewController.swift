//
//  StoryShareTutorialIntroViewController.swift
//  Elated
//
//  Created by Rey Felipe on 6/29/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import SwiftyJSON

class StoryShareTutorialIntroViewController: BaseViewController {
    
    internal let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-back").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .chestnut
        return button
    }()
    
    private let ssBackground = UIImageView(image: #imageLiteral(resourceName: "background-storyshare"))
    
    private let typeWriterBackground: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "typewriter"))
        imageView.contentMode = .top
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .chestnut
        label.font = .courierPrimeRegular(42)
        label.text = "storyshare.title".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let howToLabel: UILabel = {
        let label = UILabel()
        label.textColor = .chestnut
        label.font = .courierPrimeRegular(20)
        label.text = "common.howtoplay".localized
        label.textAlignment = .left
        return label
    }()
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .chestnut
        label.font = .courierPrimeRegular(14)
        label.text = "storyshare.howtoplay.instruction".localized
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton.createCommonBottomButton("common.continue")
        button.backgroundColor = .umber
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.hideNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hideNavBar()
    }
    
    override func initSubviews() {
        super.initSubviews()
        view.backgroundColor = .white
        
        view.addSubview(ssBackground)
        ssBackground.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(8)
            make.width.height.equalTo(40)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(100)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(typeWriterBackground)
        typeWriterBackground.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
            make.left.right.bottom.equalToSuperview()
        }
        
        typeWriterBackground.addSubview(howToLabel)
        howToLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(40)
        }
        
        typeWriterBackground.addSubview(instructionLabel)
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(howToLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(40)
        }
        
        view.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(33)
            make.bottom.equalToSuperview().offset(-40)
        }

    }
    
    override func bind() {
        super.bind()
        
        backButton.rx.tap.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: rx.disposeBag)
        
        continueButton.rx.tap.bind { [weak self] in
            guard let self = self,
                  let demoGameDetail = self.loadTutorialGameData()
            else { return }
            print(demoGameDetail)
            let vc = StoryShareTutorialGameViewController(demoGameDetail)
            vc.completionHandler = { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            self.show(vc, sender: nil)
        }.disposed(by: disposeBag)
    }
    
    
    private func loadTutorialGameData() -> StoryShareGameDetail? {
        
        if let path = Bundle.main.path(forResource: "storyshare-turotial-game-detail-1", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)
                print("jsonData:\(jsonObj)")
                var demoGameDetail = GetStoryShareResponse(jsonObj)
                demoGameDetail.storyShare?.currentPlayerTurn = MemCached.shared.userInfo?.id
                return demoGameDetail.storyShare
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
            return nil
        } else {
            print("Invalid filename/path.")
            return nil
        }
        
    }
}
