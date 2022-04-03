//
//  EmojiGoTutorialIntroViewController.swift
//  Elated
//
//  Created by Rey Felipe on 10/13/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import SwiftyJSON

class EmojiGoTutorialIntroViewController: BaseViewController {
    
    internal let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-back").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .elatedPrimaryPurple
        return button
    }()
    
    private let emojiGoLogoImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "graphic-emojiGo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let bgImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "emojiGoBackground"))
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let instructionView: UIView = {
        let view = UIView()
        view.backgroundColor = .alabasterBlue
        view.layer.cornerRadius = 10
        return view
    }()
    
    internal let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("common.continue".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.cornerRadius = 25
        button.titleLabel?.font = .comfortaaBold(14)
        button.layer.applySketchShadow(color: .black,
                                       alpha: 0.15,
                                       x: 0,
                                       y: 3,
                                       blur: 18,
                                       spread: 0)
        button.clipsToBounds = true
        button.isHidden = true
        return button
    }()
    
    private let howToLabel: UILabel = {
        let label = UILabel()
        label.textColor = .elatedPrimaryPurple
        label.font = .futuraMedium(16)
        label.text = "common.howtoplay".localized
        label.textAlignment = .left
        return label
    }()
    
    private let instructionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.text = "emojigo.howtoplay.instruction".localized
        textView.textColor = .elatedPrimaryPurple
        textView.font = .futuraMedium(14)
        textView.textAlignment = .left
        textView.backgroundColor = .alabasterBlue
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hideNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //apply gradient after layout
        continueButton.gradientBackground(from: .maximumYellowRed,
                                          to: .brightYellowCrayola,
                                          direction: .bottomToTop)
        continueButton.isHidden = false
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
        
        view.addSubview(emojiGoLogoImageView)
        emojiGoLogoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.backButton.snp.bottom)
            make.width.equalTo(258)
            make.height.equalTo(165)
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
            make.top.equalTo(emojiGoLogoImageView.snp.bottom).offset(15)
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
            print(demoGameDetail)
            let vc = EmojiGoTutorialGameViewController(demoGameDetail)
            vc.completionHandler = { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            self.show(vc, sender: nil)
        }.disposed(by: disposeBag)
    }
    
    private func loadTutorialGameData() -> EmojiGoGameDetail? {
        
        if let path = Bundle.main.path(forResource: "basho-turotial-game-detail", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)
                print("jsonData:\(jsonObj)")
                var demoGameDetail = EmojiGoGameDetail(jsonObj)
                demoGameDetail.currentPlayerTurn = MemCached.shared.userInfo?.id
                return demoGameDetail
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
