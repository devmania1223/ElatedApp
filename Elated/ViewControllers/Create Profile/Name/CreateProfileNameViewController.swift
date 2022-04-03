//
//  CreateProfileNameViewController.swift
//  Elated
//
//  Created by Marlon on 6/9/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift

class CreateProfileNameViewController: BaseViewController {

    let viewModel = EditProfileCommonViewModel()
    
    let firstNameTextField = UITextField.createNormalTextField("createProfile.firstName.placeholder".localized)
    let lastNameTextField = UITextField.createNormalTextField("createProfile.lastName.placeholder".localized)

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "createProfile.title".localized
        label.font = .futuraMedium(22)
        label.textAlignment = .center
        return label
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.text = "createProfile.note".localized
        label.font = .futuraBook(12)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    
    private let nextButton = UIButton.createCommonBottomButton("common.next")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(84)
            make.left.right.equalToSuperview().inset(33)
        }
        
        view.addSubview(firstNameTextField)
        firstNameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(60)
            make.left.right.equalTo(titleLabel)
            make.height.equalTo(50)
        }
        
        view.addSubview(lastNameTextField)
        lastNameTextField.snp.makeConstraints { make in
            make.top.equalTo(firstNameTextField.snp.bottom).offset(22)
            make.left.right.equalTo(firstNameTextField)
            make.height.equalTo(50)
        }
        
        view.addSubview(noteLabel)
        noteLabel.snp.makeConstraints { make in
            make.top.equalTo(lastNameTextField.snp.bottom).offset(10)
            make.left.right.equalTo(lastNameTextField).inset(30)
        }
        
        view.addSubview(bottomBackground)
        bottomBackground.snp.makeConstraints { make in
            make.height.equalTo(135) //including offset 2
            make.left.equalToSuperview().offset(-2)
            make.right.bottom.equalToSuperview().offset(2)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.centerY.equalTo(bottomBackground)
            make.left.right.equalToSuperview().inset(33)
            make.height.equalTo(50)
        }
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        firstNameTextField.rx.text.orEmpty.bind(to: viewModel.firstName).disposed(by: disposeBag)
        lastNameTextField.rx.text.orEmpty.bind(to: viewModel.lastName).disposed(by: disposeBag)

        Observable.combineLatest(viewModel.firstName,
                                 viewModel.lastName)
            .subscribe(onNext: { [weak self] fname, lname in
                var valid = false
                if let fn = fname,
                   let ln = lname,
                   !fn.isEmpty,
                   !ln.isEmpty {
                        valid = true
                }
                self?.nextButton.isUserInteractionEnabled = valid
                self?.nextButton.alpha = valid ? 1 : 0.6
        }).disposed(by: disposeBag)
        
        nextButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.name)
        }.disposed(by: disposeBag)
        
    }

}
