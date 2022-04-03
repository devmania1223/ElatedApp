//
//  AddDeleteTableView.swift
//  Elated
//
//  Created by Marlon on 2021/3/13.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class AddDeleteTableView: UITableView {
    
    private let disposeBag = DisposeBag()
    
    let data = BehaviorRelay<[(UIImage, URL?, String, AddDeleteTableViewCell.ButtonType)]>(value: [])
    let buttonType = BehaviorRelay<AddDeleteTableViewCell.ButtonType>(value: .display)

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.backgroundColor = .white
        self.register(AddDeleteTableViewCell.self, forCellReuseIdentifier: AddDeleteTableViewCell.identifier)
        self.separatorStyle = .none
        self.separatorColor = .clear
        self.estimatedRowHeight = 70
        self.rowHeight = UITableView.automaticDimension
        self.tableFooterView = UIView()
        self.dataSource = self
        
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


extension AddDeleteTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddDeleteTableViewCell.identifier)
            as? AddDeleteTableViewCell ?? AddDeleteTableViewCell()
        let rowData = data.value[indexPath.row]
        cell.setData(rowData.0, imageURL: rowData.1, title: rowData.2, type: rowData.3)
        return cell
    }
}

