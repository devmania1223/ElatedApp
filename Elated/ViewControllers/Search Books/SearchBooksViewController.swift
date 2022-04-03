//
//  SearchBooksViewController.swift
//  Elated
//
//  Created by Marlon on 6/4/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchBooksViewController: BaseViewController {

    let viewModel = SearchBookViewModel()
    
    class TitleView: UIView {
        
        let type = BehaviorRelay<BookSearchType>(value: .title)
        
        let titleButton: UIButton = {
            let button = UIButton()
            button.titleLabel?.font = .futuraMedium(16)
            button.setTitleColor(.white, for: .normal)
            button.setTitle("book.search.title.title".localized, for: .normal)
            return button
        }()

        let authorButton: UIButton = {
            let button = UIButton()
            button.titleLabel?.font = .futuraMedium(16)
            button.setTitleColor(.white, for: .normal)
            button.setTitle("book.search.title.author".localized, for: .normal)
            return button
        }()
        
        let line1 = UIView()
        let line2 = UIView()
        
        init() {
            super.init(frame: .zero)
            initSubviews()
            bind()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func initSubviews() {
            let stack = UIStackView(arrangedSubviews: [titleButton, authorButton])
            stack.spacing = 12
            addSubview(stack)
            stack.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
            }
            
            addSubview(line1)
            line1.snp.makeConstraints { make in
                make.top.equalTo(stack.snp.bottom).inset(4)
                make.left.right.equalTo(titleButton)
                make.height.equalTo(3)
                make.bottom.equalToSuperview()
            }
            
            addSubview(line2)
            line2.snp.makeConstraints { make in
                make.top.bottom.equalTo(line1)
                make.left.right.equalTo(authorButton)
                make.height.equalTo(3)
            }
            
        }
        
        private func bind() {
            titleButton.rx.tap.map { .title }.bind(to: type).disposed(by: rx.disposeBag)
            authorButton.rx.tap.map { .author }.bind(to: type).disposed(by: rx.disposeBag)
        }
        
        @objc private func showOptions() {
            type.accept(type.value == .title ? .author : .title)
        }
        
    }
    
    private let textField: UITextField = {
        let view = UITextField()
        view.customizeTextField(false,
                                     leftImage: nil,
                                     rightImage: #imageLiteral(resourceName: "icon-basho-search"),
                                     placeholder: "profile.editProfile.books.searchBook",
                                     colorTheme: .elatedPrimaryPurple,
                                     borderWidth: 0.25,
                                     cornerRadius: 25)
        let spacer = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
        view.leftView = spacer
        return view
    }()
    
    private let tableView = SearchBooksTableView()
    
    private let titleView = TitleView()
    
    private let confirmButton = UIBarButtonItem.createCheckButton()
    
    init(_ editType: EditInfoControllerType) {
        super.init(nibName: nil, bundle: nil)
        
        let backButton = UIBarButtonItem.createBackButton()
        backButton.tintColor = editType == .edit ? .white : .elatedPrimaryPurple
        confirmButton.tintColor = editType == .edit ? .white : .elatedPrimaryPurple
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = confirmButton
        
        backButton.rx.tap.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: rx.disposeBag)
        
        
        viewModel.editType.accept(editType)
        
        self.navigationItem.titleView = titleView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getBooks()
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22)
            make.left.right.equalToSuperview().inset(33)
            make.height.equalTo(50)
        }
    
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(22)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
        
    }

    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)

        viewModel.presentAlert.subscribe(onNext: { [weak self] args in
          let (title, message) = args
          self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)

        viewModel.searchedBooks.bind(to: tableView.data).disposed(by: disposeBag)
        viewModel.userBooks.bind(to: tableView.selectedBooks).disposed(by: disposeBag)

        textField.rx.text.orEmpty.bind(to: viewModel.keyword).disposed(by: disposeBag)
        
        titleView.type.bind(to: viewModel.searchType).disposed(by: disposeBag)
        
        tableView.didSelect.subscribe(onNext: {  [weak self] book in
            guard let self = self else { return }
            let index = self.viewModel.userBooks.value.firstIndex(where: { $0.volumeID == book.volumeID })
            if index != nil {
                //delete
                if let saved = self.viewModel.userBooks.value.first(where: { $0.volumeID == book.volumeID }),
                   let id = saved.id {
                    self.viewModel.deleteBook(id)
                }
            } else {
                self.viewModel.addBook(book)
            }
        }).disposed(by: disposeBag)
        
        tableView.getMoreSearchResults.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.viewModel.searchBooks(initialPage: false)
        }).disposed(by: disposeBag)
        
        textField.rx.controlEvent([.editingDidBegin, .editingChanged])
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.tableView.isHidden = false
                NSObject.cancelPreviousPerformRequests(withTarget: self,
                                                       selector: #selector(self.triggerSearch),
                                                       object: self.textField)
                self.perform(#selector(self.triggerSearch),
                             with: self.textField,
                             afterDelay: 0.6)
        }).disposed(by: disposeBag)
        
        titleView.type.subscribe(onNext: { [weak self] type in
            guard let self = self else { return }
            let editType = self.viewModel.editType.value
            self.titleView.titleButton.isSelected = type == .title
            self.titleView.authorButton.isSelected = type == .author
            self.titleView.line1.backgroundColor = type == .title ? (editType == .onboarding)
                ? .elatedPrimaryPurple
                : .white
                : .clear
            self.titleView.line2.backgroundColor = type == .author ? (editType == .onboarding)
                ? .elatedPrimaryPurple
                : .white
                : .clear
        }).disposed(by: rx.disposeBag)
        
        confirmButton.rx.tap.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: rx.disposeBag)
        
        viewModel.editType.subscribe(onNext: { [weak self] type in
            guard let self = self else { return }
            if type == .onboarding {
                self.titleView.titleButton.setTitleColor(.sonicSilver, for: .normal)
                self.titleView.titleButton.setTitleColor(.elatedPrimaryPurple, for: .selected)
                
                self.titleView.authorButton.setTitleColor(.sonicSilver, for: .normal)
                self.titleView.authorButton.setTitleColor(.elatedPrimaryPurple, for: .selected)
            }
        }).disposed(by: disposeBag)
                
    }
    
    @objc func triggerSearch() {
        viewModel.searchBooks(initialPage: true)
    }
    
}
