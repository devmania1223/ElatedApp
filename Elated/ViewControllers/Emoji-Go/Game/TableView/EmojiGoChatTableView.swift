//
//  EmojiGoChatTableView.swift
//  Elated
//
//  Created by Marlon on 9/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EmojiGoChatTableView: UITableView {
    
    private let disposeBag = DisposeBag()
    
    let data = BehaviorRelay<EmojiGoGameDetail?>(value: nil)
    let otherPlayerImage = BehaviorRelay<String?>(value: nil)
    private let chats = BehaviorRelay<[Any]>(value: [])
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.backgroundColor = .appLightSkyBlue
        self.register(EmojiGoTableViewTextMeCell.self, forCellReuseIdentifier: EmojiGoTableViewTextMeCell.identifier)
        self.register(EmojiGoTableViewTextOtherCell.self, forCellReuseIdentifier: EmojiGoTableViewTextOtherCell.identifier)
        self.register(EmojiGoTableViewEmojiMeCell.self, forCellReuseIdentifier: EmojiGoTableViewEmojiMeCell.identifier)
        self.register(EmojiGoTableViewEmojiOtherCell.self, forCellReuseIdentifier: EmojiGoTableViewEmojiOtherCell.identifier)
        self.contentInset = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
        self.separatorStyle = .none
        self.separatorColor = .clear
        self.estimatedRowHeight = 70
        self.rowHeight = UITableView.automaticDimension
        self.tableFooterView = UIView()
        self.dataSource = self
        self.delegate = self
        self.layer.cornerRadius = 16
        self.bind()
    }
    
    private func bind() {
        data.subscribe(onNext: { [weak self] data in
            guard let data = data else {
                return
            }
            
            var chats = [Any]()
            for emoji in data.emojigo {
                if let question = emoji.question {
                    chats.append(question)
                }
                if let answer = emoji.answer,
                   let text = emoji.answer?.answer,
                   !text.isEmpty {
                    chats.append(answer)
                }
            }
            self?.chats.accept(chats)
        }).disposed(by: disposeBag)
        
        otherPlayerImage.subscribe(onNext: { [weak self] data in
            self?.reloadData()
        }).disposed(by: disposeBag)
        
        chats.subscribe(onNext: { [weak self] _ in
            self?.reloadData()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EmojiGoChatTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let data = chats.value[indexPath.row] as? EmojiGoQuestion {
            if MemCached.shared.isSelf(id: data.user) {
                let cell = tableView.dequeueReusableCell(withIdentifier: EmojiGoTableViewTextMeCell.identifier)
                    as? EmojiGoTableViewTextMeCell ?? EmojiGoTableViewTextMeCell()
                cell.set(data.question ?? "")
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: EmojiGoTableViewTextOtherCell.identifier)
                    as? EmojiGoTableViewTextOtherCell ?? EmojiGoTableViewTextOtherCell()
                cell.set(data.question ?? "", avatar: URL(string: otherPlayerImage.value ?? ""))
                return cell
            }
        } else if let data = chats.value[indexPath.row] as? EmojiGoAnswer {
            if MemCached.shared.isSelf(id: data.user) {
                let cell = tableView.dequeueReusableCell(withIdentifier: EmojiGoTableViewEmojiMeCell.identifier)
                    as? EmojiGoTableViewEmojiMeCell ?? EmojiGoTableViewEmojiMeCell()
                cell.set(data.answer ?? "")
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: EmojiGoTableViewEmojiOtherCell.identifier)
                    as? EmojiGoTableViewEmojiOtherCell ?? EmojiGoTableViewEmojiOtherCell()
                cell.set(data.answer ?? "", avatar: URL(string: otherPlayerImage.value ?? ""))
                return cell
            }
        }
        return EmojiGoTableViewEmojiMeCell()
    }
}

extension EmojiGoChatTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //if there's any action
    }
    
}
