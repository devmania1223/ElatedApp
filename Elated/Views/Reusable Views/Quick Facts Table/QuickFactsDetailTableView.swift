//
//  QuickFactsDetailTableView.swift
//  Elated
//
//  Created by Marlon on 3/25/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class QuickFactsDetailTableView: UITableView {
    
    private let disposeBag = DisposeBag()
    
    let data = BehaviorRelay<[(String, String)]>(value: [])
    let selected = PublishRelay<Int>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.backgroundColor = .white
        self.register(QuickFactsDetailTableViewCell.self,
                      forCellReuseIdentifier: QuickFactsDetailTableViewCell.identifier)
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

extension QuickFactsDetailTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuickFactsDetailTableViewCell.identifier)
            as? QuickFactsDetailTableViewCell ?? QuickFactsDetailTableViewCell()
        let rowData = data.value[indexPath.row]
        cell.set(rowData.0, value: rowData.1)
        return cell
    }
}

extension QuickFactsDetailTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected.accept(indexPath.row)
    }
}
