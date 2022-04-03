//
//  SparkFlirtGamesTableView.swift
//  Elated
//
//  Created by Marlon on 5/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SparkFlirtGamesTableView: UITableView {
    
    private let disposeBag = DisposeBag()
        
    var data = BehaviorRelay<[GameDetail]>(value: [])
    let didNudge = PublishRelay<GameDetail>()
    let didPlay = PublishRelay<GameDetail>()
    let didSelect = PublishRelay<GameDetail>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.backgroundColor = .white
        self.register(SparkFlirtActiveTableViewCell.self, forCellReuseIdentifier: SparkFlirtActiveTableViewCell.identifier)
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


extension SparkFlirtGamesTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SparkFlirtActiveTableViewCell.identifier)
            as? SparkFlirtActiveTableViewCell ?? SparkFlirtActiveTableViewCell()
        
        let gameData = data.value[indexPath.row]
        cell.setup(gameData)
        
        cell.didNudge = { [weak self] in
            self?.didNudge.accept(gameData)
        }
        cell.didSelectPlay = { [weak self] in
            self?.didPlay.accept(gameData)
        }
        
        return cell
    }
}

extension SparkFlirtGamesTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gameData = data.value[indexPath.item]
        didSelect.accept(gameData)
    }
    
}
