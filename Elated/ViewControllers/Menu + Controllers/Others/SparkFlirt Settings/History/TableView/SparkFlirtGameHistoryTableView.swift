//
//  SparkFlirtGameHistoryTableView.swift
//  Elated
//
//  Created by Rey Felipe on 11/24/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SparkFlirtGameHistoryTableView: UITableView {
    
    private let disposeBag = DisposeBag()
    
    let data = BehaviorRelay<[GameDetail]>(value: [])
    let didSelect = PublishRelay<GameDetail>()
    let didSelectProfile = PublishRelay<Int>()
    let getMoreResults = PublishRelay<Void>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.backgroundColor = .white
        self.register(SparkFlirtGameHistoryTableViewCell.self,
                      forCellReuseIdentifier: SparkFlirtGameHistoryTableViewCell.identifier)
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

extension SparkFlirtGameHistoryTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SparkFlirtGameHistoryTableViewCell.identifier)
            as? SparkFlirtGameHistoryTableViewCell ?? SparkFlirtGameHistoryTableViewCell()
        let rowData = data.value[indexPath.row]
        cell.set(rowData)
        cell.didSelectProfile = { [weak self] id in
            self?.didSelectProfile.accept(id)
        }
        return cell
    }
}

extension SparkFlirtGameHistoryTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowData = data.value[indexPath.item]
        didSelect.accept(rowData)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = (scrollView.contentSize.height - contentYoffset) * 0.75
        // Start fetching the next page once the scroll reached 75% of the screen for a more continous scrolling.
        if distanceFromBottom < height {
            getMoreResults.accept(())
        }
    }
}
