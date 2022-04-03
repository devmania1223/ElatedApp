//
//  SparkFlirtActiveTableViewCell.swift
//  Elated
//
//  Created by Marlon on 5/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Lottie

class SparkFlirtActiveTableViewCell: UITableViewCell {

    static let identifier = "SparkFlirtActiveTableViewCell"
    
    var didNudge: (() -> Void)?
    var didSelectPlay: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "profile.sparkFlirt.game.turn.yours".localized
        label.font = .futuraMedium(16)
        label.textColor = .jet
        return label
    }()
    
    let player1ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.cornerRadius = 47
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "h8")
        return imageView
    }()
    
    let player1Label: UILabel = {
        let label = UILabel()
        label.text = "profile.sparkFlirt.you".localized
        label.font = .futuraMedium(16)
        label.textColor = .jet
        label.lineBreakMode = .byTruncatingMiddle
        label.textAlignment = .center
        return label
    }()
    
    let player2ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.cornerRadius = 47
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "odu3")
        return imageView
    }()

    let player2Label: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .futuraMedium(16)
        label.textColor = .jet
        label.lineBreakMode = .byTruncatingMiddle
        label.textAlignment = .center
        return label
    }()
    
    let turnIndicatorAnimationView: AnimationView = {
        let animation = AnimationView(name: "turn-indicator")
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.backgroundBehavior = .pauseAndRestore
        animation.layer.transform = CATransform3DMakeScale(1, -1, 1)
        animation.play()
        return animation
    }()
    
    let gameLabel: UILabel = {
        let label = UILabel()
        label.text = "profile.sparkFlirt.game".localizedFormat("")
        label.font = .futuraMedium(14)
        label.textColor = .jet
        return label
    }()
    
    let lastPlayedLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .futuraMedium(12)
        label.textColor = .silver
        return label
    }()
    
    let nudgeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "button-nudge"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "button-play"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    let view: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
        return view
    }()

    private func initSubviews() {
    
        selectionStyle = .none
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6)
            make.left.right.equalToSuperview().inset(12)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(25)
            make.centerX.equalToSuperview()
        }
        
        let line = UIView()
        line.backgroundColor = .lightGray
        view.addSubview(line)
        line.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.25)
        }
        
        view.addSubview(player1ImageView)
        player1ImageView.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(25)
            make.left.equalToSuperview().inset(16)
            make.height.width.equalTo(94)
        }
        
        view.addSubview(player1Label)
        player1Label.snp.makeConstraints { make in
            make.top.equalTo(player1ImageView.snp.bottom).offset(7)
            make.width.equalTo(player1ImageView)
            make.centerX.equalTo(player1ImageView)
        }
        
        view.addSubview(player2ImageView)
        player2ImageView.snp.makeConstraints { make in
            make.top.equalTo(player1ImageView)
            make.right.equalToSuperview().inset(16)
            make.height.width.equalTo(94)
        }
        
        view.addSubview(player2Label)
        player2Label.snp.makeConstraints { make in
            make.top.equalTo(player2ImageView.snp.bottom).offset(7)
            make.width.equalTo(player2ImageView)
            make.centerX.equalTo(player2ImageView)
        }
        
        view.addSubview(turnIndicatorAnimationView)
        turnIndicatorAnimationView.snp.makeConstraints { make in
            make.centerY.equalTo(player1ImageView)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(94)
        }
        
        let stack = UIStackView(arrangedSubviews: [gameLabel, lastPlayedLabel])
        stack.axis = .vertical
        stack.spacing = 6
        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(player2Label.snp.bottom).offset(50)
            make.left.equalTo(player1ImageView)
            make.bottom.equalToSuperview().inset(40)
        }
        
        view.addSubview(nudgeButton)
        nudgeButton.snp.makeConstraints { make in
            make.centerY.equalTo(stack)
            make.right.equalToSuperview().inset(16)
            make.width.height.equalTo(62)
        }
        nudgeButton.addTarget(self, action: #selector(nudgeAction), for: .touchUpInside)
        
        view.addSubview(playButton)
        playButton.snp.makeConstraints { make in
            make.centerY.equalTo(stack)
            make.right.equalToSuperview().inset(16)
            make.width.height.equalTo(62)
        }
        playButton.addTarget(self, action: #selector(playAction), for: .touchUpInside)
        
    }
    
    private func setImageFor(_ imageView: UIImageView, with imageUrl: String?) {
        imageView.kf.setImage(with: URL(string: imageUrl ?? ""), placeholder: #imageLiteral(resourceName: "profile-placeholder"))
    }
    
    // MARK: Actions
    @objc func nudgeAction() {
        didNudge?()
    }
    
    @objc func playAction() {
        didSelectPlay?()
    }
    
    func setup(_ game: GameDetail) {
        
        let invitee = game.detail?.invitee
        let inviter = game.detail?.inviter
        let isInviteeMe = MemCached.shared.isSelf(id: invitee?.id)
        let isInviterMe = MemCached.shared.isSelf(id: inviter?.id)
        
        let myTurn = MemCached.shared.isSelf(id: game.detail?.currentPlayerTurn)
            
        gameLabel.text = game.detail?.game?.getTitle() ?? ""
                        
        let detail = game.detail
        setImageFor(player1ImageView, with: detail?.invitee?.avatar?.image)
        setImageFor(player2ImageView, with: detail?.inviter?.avatar?.image)
        player1Label.text = isInviteeMe ? "profile.sparkFlirt.you".localized : detail?.invitee?.getDisplayName()
        player2Label.text = isInviterMe ? "profile.sparkFlirt.you".localized : detail?.inviter?.getDisplayName()
        updateAnimation(invitee?.id == game.detail?.currentPlayerTurn)
        lastPlayedLabel.text = ""
            
        //double check
        //hide buttons if game is already completed
        //TODO: Allow user to chat from here
        if game.gameStatus == .completed || game.gameStatus == .cancelled {
            titleLabel.text = game.gameStatus?.rawValue.capitalized
            nudgeButton.isHidden = true
            playButton.isHidden = true
        } else {
            titleLabel.text = myTurn ? "profile.sparkFlirt.game.turn.yours".localized : "profile.sparkFlirt.game.turn.theirs".localized
            nudgeButton.isHidden = myTurn ? true : false
            playButton.isHidden = myTurn ? false : true
        }
        var lastUpdate = ""
        if game.gameStatus == .completed {
            lastUpdate = game.gameCompleteDatetime?.stringToTimeAgo(.backend) ?? ""
        } else if game.gameStatus == .cancelled {
            lastUpdate = game.gameCancelledDatetime?.stringToTimeAgo(.backend) ?? ""
        } else if game.gameStatus == .pending {
            lastUpdate = game.gamePendingDatetime?.stringToTimeAgo(.backend) ?? ""
        } else {
            lastUpdate = game.modified?.stringToTimeAgo(.backend) ?? ""
        }
        lastPlayedLabel.text = lastUpdate.isEmpty ? lastUpdate : "profile.sparkFlirt.game.last.played".localizedFormat(lastUpdate)
            
    }

    private func updateAnimation(_ leftToRight: Bool) {
        turnIndicatorAnimationView.layer.transform = leftToRight ? CATransform3DMakeScale(-1, 1, 1) : CATransform3DMakeScale(1, -1, 1)
    }
    
}
