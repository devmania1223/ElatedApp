//
//  ProfilePhotoViewController+Bindings.swift
//  Elated
//
//  Created by Marlon on 4/30/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

extension ProfilePhotoViewController {
    
    func bindView() {
        viewModel.name.bind(to: nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.caption.bind(to: textView.rx.text).disposed(by: disposeBag)
        viewModel.caption.bind(to: captionLabel.rx.text).disposed(by: disposeBag)
        viewModel.mainImage.subscribe(onNext: { [weak self] img in
            self?.viewModel.caption.accept(img?.caption)
            self?.profileImageView.imageView.kf.setImage(with: URL(string: img?.image ?? ""), placeholder: #imageLiteral(resourceName: "profile-placeholder"))
        }).disposed(by: disposeBag)
        
        viewModel.profileImage.subscribe(onNext: { [weak self] img in
            self?.profileLogoView.kf.setImage(with: URL(string: img?.image ?? ""), placeholder: #imageLiteral(resourceName: "profile-placeholder"))
        }).disposed(by: disposeBag)
        
        viewModel.type.map { $0 == .view }.bind(to: optionButton.rx.isHidden).disposed(by: disposeBag)
        viewModel.isEditing.map { !$0 }.bind(to: optionButton.rx.isUserInteractionEnabled).disposed(by: disposeBag)
        viewModel.caption.bind(to: captionLabel.rx.text).disposed(by: disposeBag)
        viewModel.showCaption.bind(to: captionLabel.rx.isHidden).disposed(by: disposeBag)
        viewModel.showCaption.bind(to: profileGradientView.rx.isHidden).disposed(by: disposeBag)
    }
    
    func bindEvent() {
        optionButton.rx.tap.bind { [weak self] in
                guard let self = self else { return }
                self.editView.isHidden = !self.editView.isHidden
                self.bgView.isHidden = !self.bgView.isHidden
        }.disposed(by: disposeBag)
        
        editView.didEdit.subscribe(onNext: { [weak self] in
            self?.likeButton.isHidden = true
            self?.likeLabel.isHidden = true
            self?.editView.isHidden = true
            self?.bgView.isHidden = true
            self?.textView.isHidden = false
            self?.textView.becomeFirstResponder()
        }).disposed(by: disposeBag)
        
        editView.didDelete.subscribe(onNext: { [weak self] in
            self?.bgView.isHidden = true
            self?.editView.isHidden = true
        }).disposed(by: disposeBag)
        
        textView.rx.didBeginEditing.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            if self.textView.text == "profile.gallery.caption.placeholder".localized {
                self.textView.text = ""
            }
            self.viewModel.isEditing.accept(true)
        }).disposed(by: disposeBag)
        
        textView.rx.didEndEditing.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            if self.textView.text.isEmpty {
                self.textView.text = "profile.gallery.caption.placeholder".localized
            } else {
                self.viewModel.caption.accept(self.textView.text)
                self.viewModel.updateCaption()
            }
            self.textView.isHidden = true
            self.likeButton.isHidden = false
            self.likeLabel.isHidden = false
            self.viewModel.isEditing.accept(false)
        }).disposed(by: disposeBag)
        
        commentButton.rx.tap.map { [weak self] in
            guard let self = self else { return true }
            return !self.viewModel.showCaption.value
        }.bind(to: viewModel.showCaption)
        .disposed(by: disposeBag)
        
    }
    
}
