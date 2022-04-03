//
//  SearchBooksTableView.swift
//  Elated
//
//  Created by Marlon on 6/4/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchBooksTableView: UITableView {
    
    private let disposeBag = DisposeBag()
    
    let data = BehaviorRelay<[Book]>(value: [])
    let selectedBooks = BehaviorRelay<[Book]>(value: [])
    let didSelect = PublishRelay<Book>()
    let getMoreSearchResults = PublishRelay<Void>()

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.backgroundColor = .white
        self.register(SearchBooksTableViewCell.self, forCellReuseIdentifier: SearchBooksTableViewCell.identifier)
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
        Observable.combineLatest(data, selectedBooks)
            .subscribe(onNext: { [weak self] _, _ in
            self?.reloadData()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SearchBooksTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchBooksTableViewCell.identifier)
            as? SearchBooksTableViewCell ?? SearchBooksTableViewCell()
        let book = data.value[indexPath.row]
        let selected = selectedBooks.value.first(where: { $0.volumeID == book.volumeID }) != nil
        cell.set(book, selected: selected)
        return cell
    }
}

extension SearchBooksTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect.accept(data.value[indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = (scrollView.contentSize.height - contentYoffset) * 0.75
        // Start fetching the next page once the scroll reached 75% of the screen for a more continous scrolling.
        if distanceFromBottom < height {
            getMoreSearchResults.accept(())
        }
    }

}
