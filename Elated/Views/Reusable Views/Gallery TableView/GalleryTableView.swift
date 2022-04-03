//
//  GalleryTableView.swift
//  Elated
//
//  Created by Marlon on 2021/3/20.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GalleryTableView: UITableView {
    
    private let disposeBag = DisposeBag()
    
    //TODO: Change data type
    let data = BehaviorRelay<[ProfileImage]>(value: [])
    let didSelect = PublishRelay<Int>()

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.backgroundColor = .white
        self.register(GalleryTableViewCell.self, forCellReuseIdentifier: GalleryTableViewCell.identifier)
        self.separatorStyle = .none
        self.separatorColor = .clear
        self.estimatedRowHeight = 70
        self.rowHeight = UITableView.automaticDimension
        self.tableFooterView = UIView()
        self.dataSource = self
        self.delegate = self
        self.isScrollEnabled = false
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

extension GalleryTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GalleryTableViewCell.identifier)
            as? GalleryTableViewCell ?? GalleryTableViewCell()
        let image = URL(string: data.value[indexPath.row].image ?? "")
        let caption = data.value[indexPath.row].caption
        cell.set(image, caption: caption)
        return cell
    }
}

extension GalleryTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect.accept(indexPath.item)
    }
    
}
