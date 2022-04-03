//
//  SearchBooksTableViewCell.swift
//  Elated
//
//  Created by Marlon on 6/4/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class SearchBooksTableViewCell: UITableViewCell {
    
    private let coverImageView: UIImageView = {
        let view = UIImageView()
        view.borderColor = .silver
        view.borderWidth = 0.25
        view.clipsToBounds = true
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let bookTitleLabel: UILabel = {
        let view = UILabel()
        view.font = .futuraBook(14)
        view.numberOfLines = 0
        return view
    }()
    
    private let bookDescriptionLabel: UILabel = {
        let view = UILabel()
        view.font = .futuraMedium(14)
        view.numberOfLines = 0
        return view
    }()
    
    private let actionButton = UIButton()

    static let identifier = "SearchBooksTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        selectionStyle = .none
        contentView.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.left.equalToSuperview().inset(15)
            make.height.equalTo(88)
            make.width.equalTo(60)
        }
        
        contentView.addSubview(bookTitleLabel)
        bookTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImageView)
            make.left.equalTo(coverImageView.snp.right).offset(5)
        }
        
        contentView.addSubview(bookDescriptionLabel)
        bookDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(bookTitleLabel.snp.bottom).offset(2)
            make.left.right.equalTo(bookTitleLabel)
            make.bottom.lessThanOrEqualTo(coverImageView)
        }
        
        contentView.addSubview(actionButton)
        actionButton.isUserInteractionEnabled = false //allows tap on the whole view
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(bookTitleLabel)
            make.left.equalTo(bookTitleLabel.snp.right).offset(12)
            make.right.equalToSuperview().inset(15)
            make.height.width.equalTo(36)
        }
        
    }
    
    func set(_ book: Book, selected: Bool) {
        coverImageView.kf.setImage(with: URL(string: book.cover ?? ""))
        bookTitleLabel.text = book.title ?? ""
        bookDescriptionLabel.text = book.authors.joined(separator: ", ")
        actionButton.setImage(selected ? #imageLiteral(resourceName: "icon-remove") : #imageLiteral(resourceName: "icon-add"), for: .normal)
    }
    
}
