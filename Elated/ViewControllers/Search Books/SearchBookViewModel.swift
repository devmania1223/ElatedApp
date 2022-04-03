//
//  SearchBookViewModel.swift
//  Elated
//
//  Created by Marlon on 6/4/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
import Moya

enum BookSearchType: String {
    case title
    case author
    
    func searchNavTitle() -> String {
        switch self {
        case .title:
            return "book.search.title.title".localized
        default:
            return "book.search.title.author".localized
        }
    }
}

class SearchBookViewModel: BaseViewModel {

    let userBooks = BehaviorRelay<[Book]>(value: [])
    let searchedBooks = BehaviorRelay<[Book]>(value: [])
    private let searchedBookNextPage = BehaviorRelay<Int?>(value: nil)
    private let isFetchingSearchedBook = BehaviorRelay<Bool>(value: false)
    let searchType = BehaviorRelay<BookSearchType>(value: .author)
    let keyword = BehaviorRelay<String>(value: "")
    let editType = BehaviorRelay<EditInfoControllerType>(value: .edit)
    let next = PublishRelay<Void>()

    override init() {
        super.init()
        
        searchType.subscribe(onNext: { [weak self] _ in
            self?.searchBooks(initialPage: true)
        }).disposed(by: self.disposeBag)
        
    }
    
    func getBooks() {
        ApiProvider.shared.request(UserSettingsService.getBookList(page: 1))
            .subscribe(onSuccess: { [weak self] res in
            let response = BookResponse(JSON(res))
            self?.userBooks.accept(response.books)
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            #if DEBUG
            print(err)
            #endif
            if let code = BasicResponse(json).code {
                let message = LanguageManager.shared.errorMessage(for: code)
                //present alert triggers binding on the view controller, make sure its handled
                print(message)
                self?.presentAlert.accept(("", message))
            }
        }).disposed(by: self.disposeBag)
    }
    
    func addBook(_ book: Book) {
        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(UserSettingsService.createBook(book: book))
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
            self?.getBooks()
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            #if DEBUG
            print(err)
            #endif
            if let code = BasicResponse(json).code {
                let message = LanguageManager.shared.errorMessage(for: code)
                //present alert triggers binding on the view controller, make sure its handled
                print(message)
                self?.presentAlert.accept(("", message))
            }
        }).disposed(by: self.disposeBag)
    }
    
    func deleteBook(_ id: Int) {
        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(UserSettingsService.deleteBook(id: id))
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
            self?.getBooks()
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            #if DEBUG
            print(err)
            #endif
            if let code = BasicResponse(json).code {
                let message = LanguageManager.shared.errorMessage(for: code)
                //present alert triggers binding on the view controller, make sure its handled
                print(message)
                self?.presentAlert.accept(("", message))
            }
        }).disposed(by: self.disposeBag)
    }
    
    func searchBooks(initialPage: Bool) {
        guard !isFetchingSearchedBook.value else { return }
        var page = 1
        if !initialPage {
            guard let nextPage = searchedBookNextPage.value else { return }
            page = nextPage
        }
        isFetchingSearchedBook.accept(true)
        
        ApiProvider.shared.request(UserSettingsService.searchBook(page: page,
                                                                  searchKeyword: keyword.value,
                                                                  searchType: searchType.value.rawValue))
            .subscribe(onSuccess: { [weak self] res in
                guard let self = self else { return }
                let response = BookResponse(JSON(res))
                self.searchedBookNextPage.accept(response.next)
                if page == 1 {
                    self.searchedBooks.accept(response.books)
                } else {
                    self.searchedBooks.append(contentsOf: response.books)
                }
                self.isFetchingSearchedBook.accept(false)
            }, onError: { [weak self] err in
                self?.isFetchingSearchedBook.accept(false)
            }).disposed(by: self.disposeBag)
    }
    
}
