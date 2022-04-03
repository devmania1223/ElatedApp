//
//  BashoTutorialIntroViewController.swift
//  Elated
//
//  Created by Rey Felipe on 9/16/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import SwiftyJSON

class BashoTutorialIntroViewController: BaseViewController {
    
    internal let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-back").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let topImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "graphic-basho-flowers"))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.opacity = 0.5
        return imageView
    }()
    
    private let bashoLogoImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logo-basho"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let bgImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Basho BG"))
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let instructionView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let howToLabel: UILabel = {
        let label = UILabel()
        label.textColor = .elatedPrimaryPurple
        label.font = .futuraMedium(16)
        label.text = "basho.howtoplay".localized
        label.textAlignment = .left
        return label
    }()
    
    private let instructionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.text = "basho.howtoplay.instruction".localized
        textView.textColor = .elatedPrimaryPurple
        textView.font = .futuraMedium(14)
        textView.textAlignment = .left
        return textView
    }()
    
    internal let continueButton = UIButton.createCommonBottomButton("common.continue")

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hideNavBar()
    }
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(-2)
            make.right.equalToSuperview().offset(2)
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(8)
            make.width.height.equalTo(40)
        }
        
        view.addSubview(topImageView)
        topImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(204)
        }
        
        view.addSubview(bashoLogoImageView)
        bashoLogoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(150)
        }
        
        view.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(33)
            make.bottom.equalToSuperview().offset(-25)
        }
        
        view.addSubview(instructionView)
        instructionView.snp.makeConstraints { make in
            make.top.equalTo(bashoLogoImageView.snp.bottom)
            make.left.right.equalToSuperview().inset(33)
            make.bottom.equalTo(continueButton.snp.top).offset(-25)
        }
        
        instructionView.addSubview(howToLabel)
        howToLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(14)
        }
        
        instructionView.addSubview(instructionTextView)
        instructionTextView.snp.makeConstraints { make in
            make.top.equalTo(howToLabel.snp.bottom).offset(10)
            make.bottom.leading.trailing.equalToSuperview().inset(10)
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
            
            let vc = BashoTutorialGameViewController(demoGameDetail)
            vc.completionHandler = { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            self.show(vc, sender: nil)
        }.disposed(by: disposeBag)
    }
    
    private func loadTutorialGameData() -> BashoGameDetail? {
        
        if let path = Bundle.main.path(forResource: "basho-turotial-game-detail", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)
                print("jsonData:\(jsonObj)")
                return BashoGameDetail(jsonObj)
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
