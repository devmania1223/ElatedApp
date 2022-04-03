//
//  ProfileInterestViewController+Bindings.swift
//  Elated
//
//  Created by Marlon on 2021/3/14.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import SpotifyLogin
import SafariServices

extension ProfileInterestViewController {

    func bindViews() {
        //base bindings
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        viewModel.info.bind(to: infoLabel.rx.text).disposed(by: disposeBag)
        viewModel.nameAge.bind(to: nameLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.likes.bind(to: likesCollectionView.data).disposed(by: disposeBag)
        viewModel.dislikes.bind(to: dislikesCollectionView.data).disposed(by: disposeBag)
        
    }
    
    func bindEvents() {
        
        viewModel.images.subscribe(onNext: { [weak self] args in
            self?.profileImageView.imageView.kf.setImage(with: URL(string: args.first?.image ?? ""), placeholder: #imageLiteral(resourceName: "profile-placeholder"))
        }).disposed(by: disposeBag)
        
        viewModel.books.subscribe(onNext: {  [weak self] book in
            guard let self = self else { return }
            self.booksCollectionView.data.accept(book)
            let shouldHideTable = book.count == 0
                        
            self.booksCollectionView.isHidden = shouldHideTable
            self.booksCollectionView.snp.remakeConstraints { make in
                make.top.equalTo(self.booksStack.snp.bottom).offset(shouldHideTable ? 0 : 16)
                make.left.right.equalTo(self.dislikesCollectionView)
                make.height.equalTo(shouldHideTable ? 0 : self.booksCollectionView.requiredHeight)
            }
        }).disposed(by: disposeBag)
        
        addBookView.didTap.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.show(EditBooksViewController(.edit), sender: nil)
        }).disposed(by: disposeBag)

        addMusicView.didTap.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.show(EditMusicViewController(.edit), sender: nil)
        }).disposed(by: disposeBag)
        
        viewModel.artists.subscribe(onNext: {  [weak self] artists in
            guard let self = self else { return }
            let data = artists.map { (#imageLiteral(resourceName: "icon-spotify"), $0.images.first?.url, $0.name ?? "", AddDeleteTableViewCell.ButtonType.display) }
            self.spotifyTableView.data.accept(data)
            let shouldHide = artists.count == 0
            
            self.addMusicView.isHidden = !shouldHide

            let multiplier = (self.spotifyTableView.data.value.count == 0 ? 1 : self.spotifyTableView.data.value.count)
            self.spotifyTableView.isHidden = shouldHide
            self.spotifyTableView.snp.remakeConstraints { make in
                make.top.equalTo(self.spotifyStack.snp.bottom).offset(shouldHide ? 0 : 14)
                make.left.right.equalTo(self.addBookView)
                make.height.equalTo(shouldHide ? 0 : multiplier * 70)
                if !shouldHide {
                    make.bottom.equalToSuperview().inset(50)
                }
            }
        }).disposed(by: disposeBag)
        
        booksCollectionView.getMoreBooks.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.viewModel.getBooks(initialPage: false)
        }).disposed(by: disposeBag)
        
    }
    
}
