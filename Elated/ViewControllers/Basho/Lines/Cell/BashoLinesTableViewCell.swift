//
//  BashoLinesTableViewCell.swift
//  Elated
//
//  Created by Marlon on 4/14/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class BashoLinesTableViewCell: UITableViewCell {
    
    static let identifier = "BashoLinesTableViewCell"
    
    private let profileImageView: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "profile-placeholder"))
        view.layer.cornerRadius = 22.5
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.borderWidth = 0.25
        view.borderColor = .elatedPrimaryPurple
        return view
    }()
        
    private lazy var line5StackView: UIStackView = {
        let line1 = createLine()
        let line2 = createLine()
        let line3 = createLine()
        let line4 = createLine()
        let line5 = createLine()
        let view = UIStackView(arrangedSubviews: [line1, line2, line3, line4, line5])
        view.spacing = 10
        view.distribution = .fillEqually
        return view
    }()
    
    private lazy var line7StackView: UIStackView = {
        let line1 = createLine()
        let line2 = createLine()
        let line3 = createLine()
        let line4 = createLine()
        let line5 = createLine()
        let line6 = createLine()
        let line7 = createLine()
        let view = UIStackView(arrangedSubviews: [line1, line2, line3, line4, line5, line6, line7])
        view.spacing = 10
        view.distribution = .fillEqually
        return view
    }()
    
    private lazy var lineLabel: UILabel = {
        let label = UILabel()
        label.font = .futuraMedium(14)
        label.textColor = .elatedPrimaryPurple
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubviews()
    }

    private func initSubviews() {
       
        backgroundColor = .clear
        selectionStyle = .none
        
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6)
            make.left.right.equalToSuperview()
        }
        
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.left.equalTo(18)
            make.top.bottom.equalToSuperview().inset(15)
            make.height.width.equalTo(45)
        }
        
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.left.equalTo(18)
            make.top.bottom.equalToSuperview().inset(15)
            make.height.width.equalTo(45)
        }
        
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.left.equalTo(18)
            make.top.bottom.equalToSuperview().inset(15)
            make.height.width.equalTo(45)
        }
        
        view.addSubview(line5StackView)
        line5StackView.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(13)
            make.right.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(22)
        }
        
        view.addSubview(line7StackView)
        line7StackView.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(13)
            make.right.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(22)
        }
        
        view.addSubview(lineLabel)
        lineLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(13)
            make.right.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(22)
        }
        
    }

    func set(_ basho: String, line: HaikuLine, profileImage: URL?) {
        profileImageView.kf.setImage(with: profileImage, placeholder: #imageLiteral(resourceName: "profile-placeholder"))
        if basho.isEmpty {
            lineLabel.isHidden = true
            if line == .middle {
                line5StackView.isHidden = true
                line7StackView.isHidden = false
            } else {
                line5StackView.isHidden = false
                line7StackView.isHidden = true
            }
        } else {
            lineLabel.text = basho
            lineLabel.isHidden = false
            line5StackView.isHidden = true
            line7StackView.isHidden = true
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createLine() -> UIView {
        let view = UIView()
        view.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(30)
            make.height.equalTo(2.5)
        }
        view.backgroundColor = .elatedPrimaryPurple
        return view
    }
    
}

