//
//  EditBooksViewController.swift
//  Elated
//
//  Created by Marlon on 6/5/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class EditBooksViewController: ScrollViewController {

    let viewModel = EditProfileCommonViewModel()
    private let skipButton = UIBarButtonItem.creatTextButton("common.skip".localized)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "profile.editProfile.booksTitle".localized
        label.font = .futuraMedium(22)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let subLabel: UILabel = {
        let label = UILabel()
        label.text = "profile.editProfile.booksSubTitle".localized
        label.font = .futuraBook(18)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .sonicSilver
        return label
    }()
        
    internal lazy var booksStack = createTitleStack("profile.interests.favoriteBooks", icon: #imageLiteral(resourceName: "icon-books"))
    internal lazy var booksCollectionView = BookCollectionView(shouldHideDeleteButton: false)
    
    
    internal lazy var addBookView: AddDeleteTableViewCell = {
        let view = AddDeleteTableViewCell()
        view.setData(#imageLiteral(resourceName: "icon-books-bg"), imageURL: nil, title: "profile.interests.addMoreBooks".localized, type: .add)
        view.button.isUserInteractionEnabled = false
        return view
    }()
    
    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    
    private let nextButton = UIButton.createCommonBottomButton("common.next")
    
    init(_ type: EditInfoControllerType) {
        super.init(nibName: nil, bundle: nil)
        viewModel.editType.accept(type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let type = viewModel.editType.value
        self.navigationItem.rightBarButtonItem = type == .onboarding ? skipButton : nil
        self.setupNavigationBar(type == .onboarding ? .elatedPrimaryPurple : .white,
                                font: .futuraMedium(20),
                                tintColor: type == .onboarding ? .elatedPrimaryPurple : .white,
                                backgroundImage: type == .onboarding ? nil : #imageLiteral(resourceName: "background-header"),
                                addBackButton: type != .onboarding)
        viewModel.getBooks(initialPage: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(viewModel.titleLabelTopSpace.value)
            make.left.right.equalToSuperview().inset(50)
        }
        
        contentView.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalTo(titleLabel)
        }
        
        contentView.addSubview(booksStack)
        booksStack.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(50)
            make.left.equalToSuperview().inset(33)
        }
        
        contentView.addSubview(booksCollectionView)
        booksCollectionView.snp.makeConstraints { make in
            make.top.equalTo(booksStack.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(33)
            make.height.equalTo(0.5)
        }
        
        contentView.addSubview(addBookView)
        addBookView.snp.makeConstraints { make in
            make.top.equalTo(booksCollectionView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(15.5)
            make.bottom.equalToSuperview().inset(32)
        }
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
                
        viewModel.userBooks.subscribe(onNext: { [weak self] books in
            guard let self = self else { return }
            
            self.booksCollectionView.data.accept(books)
            
            //self.booksStack.isHidden = books.count == 0
            self.booksCollectionView.isHidden = books.count == 0
            
            self.booksCollectionView.snp.updateConstraints { make in
                make.height.equalTo(books.count == 0 ? 0 : self.booksCollectionView.requiredHeight)
            }
        }).disposed(by: disposeBag)
        
        skipButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.bio)
        }.disposed(by: disposeBag)
        
        viewModel.editType.subscribe(onNext: { [weak self] type in
            guard let self = self else { return }
            self.title = type == .edit ? "profile.editProfile.title".localized : ""
            if type == .onboarding {
                self.view.addSubview(self.bottomBackground)
                self.bottomBackground.snp.makeConstraints { make in
                    make.height.equalTo(135) //including offset 2
                    make.left.equalToSuperview().offset(-2)
                    make.right.bottom.equalToSuperview().offset(2)
                }
                
                self.view.addSubview(self.nextButton)
                self.nextButton.snp.makeConstraints { make in
                    make.centerY.equalTo(self.bottomBackground)
                    make.left.right.equalToSuperview().inset(33)
                    make.height.equalTo(50)
                }
                self.skipButton.tintColor = .elatedPrimaryPurple
                
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 140, right: 0)
            }
        }).disposed(by: disposeBag)
        
        nextButton.rx.tap.bind { [weak self] in
            self?.viewModel.success.accept(())
        }.disposed(by: disposeBag)
        
        skipButton.rx.tap.bind { [weak self] in
            self?.viewModel.success.accept(())
        }.disposed(by: disposeBag)
        
        addBookView.didTap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.show(SearchBooksViewController(self.viewModel.editType.value), sender: self)
        }).disposed(by: disposeBag)
        
        booksCollectionView.didDelete.subscribe(onNext: { [weak self] index in
            guard let self = self  else { return }
            let books = self.viewModel.userBooks.value
            guard let id = books[index].id else { return }
            
            self.viewModel.deleteBook(id)
        }).disposed(by: disposeBag)
        
        booksCollectionView.getMoreBooks.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.viewModel.getBooks(initialPage: false)
        }).disposed(by: disposeBag)
        
    }

    private func createTitleStack(_ title: String, icon: UIImage) -> UIStackView {
        let image = UIImageView(image: icon)
        let label = UILabel()
        label.font = .futuraMedium(12)
        label.text = title.localized
        let stackView = UIStackView(arrangedSubviews: [image, label])
        stackView.spacing = 6.5
        return stackView
    }
    
}
