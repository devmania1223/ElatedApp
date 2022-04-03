//
//  EditProfileReligionViewController.swift
//  Elated
//
//  Created by Marlon on 3/29/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class EditProfileReligionViewController: ScrollViewController {

    let viewModel = EditProfileCommonViewModel()
    private let saveButton = UIBarButtonItem.creatTextButton("common.save".localized)
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "profile.editProfile.religionTitle".localized
        label.font = .futuraMedium(22)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let segment =  YesNoSegment(.yes)
    
    private lazy var collectionView = CommonCollectionView([CommonDataModel(nil, title: Religion.christian.rawValue.capitalized),
                                                            CommonDataModel(nil, title: Religion.catholic.rawValue.capitalized),
                                                            CommonDataModel(nil, title: Religion.muslim.rawValue.capitalized),
                                                            CommonDataModel(nil, title: Religion.hindu.rawValue.capitalized),
                                                            CommonDataModel(nil, title: Religion.buddhist.rawValue.capitalized),
                                                            CommonDataModel(nil, title: Religion.agnostic.rawValue.capitalized),
                                                            CommonDataModel(nil, title: Religion.atheist.rawValue.capitalized),
                                                            CommonDataModel(nil, title: Religion.other.rawValue.capitalized)],
                                                           isEdit: false,
                                                           selectionType: .single)
    
    private let textField = UITextField.createNormalTextField("profile.editProfile.religion.placeholder",
                                                              font: .futuraBook(14),
                                                              cornerRadius: 25)
    
    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    
    private let nextButton = UIButton.createCommonBottomButton("common.next")
    
    init(_ type: EditInfoControllerType, religion: String) {
        super.init(nibName: nil, bundle: nil)
        if let index = collectionView.data.value.firstIndex(where: { $0.title == religion.capitalized }) {
            collectionView.selectedItems.accept([index])
        } else if Religion(rawValue: religion) == Religion.none {
            segment.state.accept(.no)
        } else {
            collectionView.selectedItems.accept([7]) //other
            textField.text = religion
        }
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
        self.navigationItem.rightBarButtonItem = type == .onboarding ? nil : saveButton
        self.setupNavigationBar(type == .onboarding ? .elatedPrimaryPurple : .white,
                                font: .futuraMedium(20),
                                tintColor: type == .onboarding ? .elatedPrimaryPurple : .white,
                                backgroundImage: type == .onboarding ? nil : #imageLiteral(resourceName: "background-header"),
                                addBackButton: type != .onboarding)
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(viewModel.titleLabelTopSpace.value)
            make.left.right.equalToSuperview().inset(50)
        }
        
        contentView.addSubview(segment)
        segment.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(segment.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(32)
        }
        
        contentView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(40)
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(32)
            make.bottom.equalToSuperview().inset(32)
        }
        textField.isHidden = true
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        textField.rx.text.orEmpty.bind(to: viewModel.otherReligion).disposed(by: disposeBag)

        segment.state.subscribe(onNext: { [weak self] state in
            self?.collectionView.isHidden = state == .no
            if state == .no {
                self?.viewModel.religion.accept(Religion.none)
                self?.collectionView.selectedItems.accept([])
                self?.collectionView.reloadData()
            }
        }).disposed(by: disposeBag)
            
        collectionView.selectedItems.subscribe(onNext: { [weak self] items in
            guard let self = self else { return }
            if let first = items.first {
                let religion = self.segment.state.value == .yes
                    ? Religion(rawValue: self.collectionView.data.value[first].title.uppercased())
                                : Religion.none
                self.viewModel.religion.accept(religion)
                self.textField.isHidden = religion == .other ? false : true
            } else {
                self.textField.isHidden = true
            }
        }).disposed(by: disposeBag)
        
        saveButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.religion)
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
                
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 140, right: 0)
            }
        }).disposed(by: disposeBag)
        
        viewModel.religion.subscribe(onNext: { [weak self] arg in
            let valid = arg != nil
            self?.nextButton.isUserInteractionEnabled = valid
            self?.nextButton.alpha = valid ? 1 : 0.6
        }).disposed(by: disposeBag)
        
        nextButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.religion)
        }.disposed(by: disposeBag)
        
        viewModel.success.subscribe(onNext: { [weak self] args in
            if self?.viewModel.editType.value != .onboarding {
                self?.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)
        
    }

}

