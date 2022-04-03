//
//  EmojiQuestionView.swift
//  Elated
//
//  Created by Marlon on 9/13/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

class EmojiQuestionView: UIView {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    let disposeBag = DisposeBag()
    
    private var questions = [EmojiGoQuestion]()
    
    private lazy var buttonQuestion1 = createButton("")
    private lazy var buttonQuestion2 = createButton("")
    private lazy var buttonQuestion3 = createButton("")
    
    private let selectedButton = BehaviorRelay<UIButton?>(value: nil)
    let selectedQuestion = BehaviorRelay<EmojiGoQuestion?>(value: nil)

    private let buttonQuestionCustom: UIButton = {
        let button = UIButton()
        button.setTitle("emojiGo.question.keyboard.token".localized, for: .normal)
        button.cornerRadius = 25
        button.borderWidth = 2
        button.borderColor = .napiesYellow
        button.titleLabel?.font = .comfortaaBold(12)
        button.titleLabel?.minimumScaleFactor = 0.5
        button.setTitleColor(.jet, for: .normal)
        button.backgroundColor = .white
        return button
    }()

    private let keyboardLogo: UIImageView = {
        let view = UIImageView()
        view.cornerRadius = 21.5
        view.image = #imageLiteral(resourceName: "icon_keyboard_small")
        view.contentMode = .center
        view.backgroundColor = .lavanderFloral
        return view
    }()
    
    init(_ questions: [EmojiGoQuestion], isKeyboard: Bool) {
        super.init(frame: .zero)
        
        let keyboard = EmojiGoQuestion(JSON([]))
        var newQuestions = questions
        newQuestions.append(keyboard)
        self.questions = newQuestions

        buttonQuestion1 = createButton(questions[0].question ?? "")
        buttonQuestion2 = createButton(questions[1].question ?? "")
        buttonQuestion3 = createButton(questions[2].question ?? "")
        
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        
        initSubviews(questions, isKeyboard: isKeyboard)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews(_ questions: [EmojiGoQuestion], isKeyboard: Bool) {
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "elated-background-gradient-color"))
        imageView.clipsToBounds = true
        imageView.cornerRadius = 16
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.cornerRadius = 16
        
        buttonQuestion1.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        buttonQuestion2.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        buttonQuestion3.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        buttonQuestionCustom.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        stackView.addArrangedSubview(buttonQuestion1)
        stackView.addArrangedSubview(buttonQuestion2)
        stackView.addArrangedSubview(buttonQuestion3)
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(22)
        }
            
        if isKeyboard {
            stackView.addArrangedSubview(buttonQuestionCustom)
            self.addSubview(keyboardLogo)
            keyboardLogo.snp.makeConstraints { make in
                make.height.width.equalTo(43)
                make.left.equalToSuperview().inset(20)
                make.centerY.equalTo(buttonQuestionCustom)
            }
        }
        
    }
    
    private func bind() {
        
        buttonQuestion1.rx.tap
            .map { [unowned self] in return self.buttonQuestion1 }
            .bind(to: selectedButton)
            .disposed(by: disposeBag)
        
        buttonQuestion2.rx.tap
            .map { [unowned self] in return self.buttonQuestion2 }
            .bind(to: selectedButton)
            .disposed(by: disposeBag)
        
        buttonQuestion3.rx.tap
            .map { [unowned self] in return self.buttonQuestion3 }
            .bind(to: selectedButton)
            .disposed(by: disposeBag)
        
        buttonQuestionCustom.rx.tap
            .map { [unowned self] in return self.buttonQuestionCustom }
            .bind(to: selectedButton)
            .disposed(by: disposeBag)

        selectedButton.subscribe(onNext: { [weak self] button in
            guard let self = self else { return }
            switch button {
            case self.buttonQuestion1:
                self.buttonQuestion1.backgroundColor = .napiesYellow
                self.buttonQuestion2.backgroundColor = .white
                self.buttonQuestion3.backgroundColor = .white
                self.buttonQuestionCustom.backgroundColor = .white
                self.selectedQuestion.accept(self.questions[0])
            case self.buttonQuestion2:
                self.buttonQuestion2.backgroundColor = .napiesYellow
                self.buttonQuestion1.backgroundColor = .white
                self.buttonQuestion3.backgroundColor = .white
                self.buttonQuestionCustom.backgroundColor = .white
                self.selectedQuestion.accept(self.questions[1])
            case self.buttonQuestion3:
                self.buttonQuestion3.backgroundColor = .napiesYellow
                self.buttonQuestion1.backgroundColor = .white
                self.buttonQuestion2.backgroundColor = .white
                self.buttonQuestionCustom.backgroundColor = .white
                self.selectedQuestion.accept(self.questions[2])
            case self.buttonQuestionCustom:
                self.buttonQuestionCustom.backgroundColor = .napiesYellow
                self.buttonQuestion1.backgroundColor = .white
                self.buttonQuestion2.backgroundColor = .white
                self.buttonQuestion3.backgroundColor = .white
                self.selectedQuestion.accept(self.questions[3])
            default:
                self.buttonQuestionCustom.backgroundColor = .white
                self.buttonQuestion1.backgroundColor = .white
                self.buttonQuestion2.backgroundColor = .white
                self.buttonQuestion3.backgroundColor = .white
                self.selectedQuestion.accept(nil)
                break
            }
        }).disposed(by: disposeBag)
        
    }
    
    private func createButton(_ text: String) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.setTitleColor(.jet, for: .normal)
        button.backgroundColor = .white
        button.cornerRadius = 25
        button.borderWidth = 2
        button.borderColor = .napiesYellow
        button.titleLabel?.font = .comfortaaBold(12)
        button.titleLabel?.minimumScaleFactor = 0.6
        button.titleLabel?.numberOfLines = 3
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textAlignment = .center
        button.titleEdgeInsets = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
        return button
    }

}
