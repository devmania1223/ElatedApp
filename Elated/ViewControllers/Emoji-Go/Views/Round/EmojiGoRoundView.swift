//
//  EmojiGoRoundView.swift
//  Elated
//
//  Created by Marlon on 9/24/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class EmojiGoRoundView: UIView {
    
    let didDismiss = PublishRelay<Void>()
    let disposeBag = DisposeBag()
    
    private let roundView: UIView = {
        let view = UIView()
        view.layer.applySketchShadow(color: .blizzardBlue,
                                     alpha: 0.15,
                                     x: 0,
                                     y: 3,
                                     blur: 18,
                                    spread: 0)
        view.clipsToBounds = true
        return view
    }()
    
    private let rountLabel: UILabel = {
        let label = UILabel()
        label.font = .comfortaaBold(16)
        label.textColor = .elatedPrimaryPurple
        label.textAlignment = .center
        return label
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.font = .comfortaaBold(12)
        label.textColor = .elatedPrimaryPurple
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    init(_ detail: EmojiGoGameDetail, turnSkipped: Bool, keyboardEarned: Bool) {
        super.init(frame: UIScreen.main.bounds)
        
        let name = MemCached.shared.isSelf(id: detail.invitee?.id) &&
            MemCached.shared.isSelf(id: detail.currentPlayerTurn)
        ? detail.inviter?.firstName : detail.invitee?.firstName

        if turnSkipped {
            initTurnSkipped(name: name ?? "")
        } else if keyboardEarned {
            initKeyboardEarned()
        } else if detail.turnType == .question {
            initQuestion(round: detail.round, name: name ?? "")
        } else if detail.turnType == .answer {
            initAnswer(round: detail.round)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initTurnSkipped(name: String) {
        rountLabel.text = "emojiGo.round.skipped.question".localized
        subLabel.text = "emojiGo.round.skipped.question.message".localizedFormat("\(name)")
        initSubviews()
    }
    
    private func initKeyboardEarned() {
        rountLabel.text = "emojiGo.round.earned.keyboard".localized
        subLabel.text = "emojiGo.round.earned.keyboard.message".localized
        initSubviews()
    }
    
    private func initQuestion(round: Int, name: String) {
        rountLabel.text = "emojiGo.round".localizedFormat("\(round)")
        subLabel.text = "emojiGo.turn.send.question".localizedFormat("\(name)")
        initSubviews()
    }
    
    private func initAnswer(round: Int) {
        rountLabel.text = "emojiGo.round".localizedFormat("\(round)")
        subLabel.text = "emojiGo.turn.send.answer".localizedFormat("\(round)")
        initSubviews()
    }
    
    private func initSubviews() {
                
        self.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
        
        addSubview(roundView)
        roundView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(56)
        }
        
        roundView.addSubview(rountLabel)
        rountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.centerX.equalToSuperview()
        }
        
        roundView.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(rountLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(18)
        }
        
    }
    
    @objc private func dismiss() {
        UIView.animate(withDuration: 0.4) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
            self.didDismiss.accept(())
        }
    }
    
    func applyGradient() {
        DispatchQueue.main.async { [weak self] in
            self?.roundView.gradientBackground(from: .alabasterBlue,
                                               to: .alabasterBlueLight,
                                               direction: .topToBottom)
            self?.roundView.cornerRadius = 15
        }
    }

}
