//
//  SparkFlirtChatTableView.swift
//  Elated
//
//  Created by Marlon on 5/5/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SparkFlirtChatTableView: UITableView {
    
    private let disposeBag = DisposeBag()
    
    let data = BehaviorRelay<[FirebaseChatMessage]>(value: [])
    let otherUserDetail = BehaviorRelay<UserInfoShort?>(value: nil)
    let viewImage = PublishRelay<URL>()
    let longPressedForIndex = PublishRelay<Int>()

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.backgroundColor = .white
        self.register(SparkFlirtChatTextOtherTableViewCell.self,
                      forCellReuseIdentifier: SparkFlirtChatTextOtherTableViewCell.identifier)
        self.register(SparkFlirtChatTextMeTableViewCell.self,
                      forCellReuseIdentifier: SparkFlirtChatTextMeTableViewCell.identifier)
        self.register(SparkFlirtChatImageOtherTableViewCell.self,
                      forCellReuseIdentifier: SparkFlirtChatImageOtherTableViewCell.identifier)
        self.register(SparkFlirtChatImageMeTableViewCell.self,
                      forCellReuseIdentifier: SparkFlirtChatImageMeTableViewCell.identifier)
        self.separatorStyle = .none
        self.separatorColor = .clear
        self.estimatedRowHeight = 70
        self.rowHeight = UITableView.automaticDimension
        self.tableFooterView = UIView()
        self.dataSource = self
        self.delegate = self
        self.bind()
    }
    
    private func bind() {
        data.subscribe(onNext: { [weak self] _ in
            self?.reloadData()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension SparkFlirtChatTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = data.value[indexPath.row]

        if MemCached.shared.isSelf(id: message.sender) {
            if message.isImage && !message.isDeleted {
                let cell = tableView.dequeueReusableCell(withIdentifier: SparkFlirtChatImageMeTableViewCell.identifier)
                    as? SparkFlirtChatImageMeTableViewCell ?? SparkFlirtChatImageMeTableViewCell()
                cell.set(url: message.image, time: message.created)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: SparkFlirtChatTextMeTableViewCell.identifier)
                    as? SparkFlirtChatTextMeTableViewCell ?? SparkFlirtChatTextMeTableViewCell()
                cell.set(message)
                return cell
            }
        } else {
            if message.isImage && !message.isDeleted {
                let cell = tableView.dequeueReusableCell(withIdentifier: SparkFlirtChatImageOtherTableViewCell.identifier)
                    as? SparkFlirtChatImageOtherTableViewCell ?? SparkFlirtChatImageOtherTableViewCell()
                cell.set(url: message.image, time: message.created)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: SparkFlirtChatTextOtherTableViewCell.identifier)
                    as? SparkFlirtChatTextOtherTableViewCell ?? SparkFlirtChatTextOtherTableViewCell()
                cell.set(message)
                return cell
            }
        }
    }
    
}

extension SparkFlirtChatTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = data.value[indexPath.row]
        if let image = message.image {
            viewImage.accept(image)
        }
    }
    
}
