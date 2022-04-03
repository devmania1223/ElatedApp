//
//  ProfileGalleryViewController+Bindings.swift
//  Elated
//
//  Created by Marlon on 5/21/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

extension ProfileGalleryViewController {

    func bindView() {
        
        //base bindings
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        viewModel.info.bind(to: infoLabel.rx.text).disposed(by: disposeBag)
        viewModel.nameAge.bind(to: nameLabel.rx.text).disposed(by: disposeBag)
        
    }
    
    func bindEvent() {
        
        tabView.layout.subscribe(onNext: { [weak self] layout in
            layout == .tile ? self?.setupTileView() : self?.setupGridView()
        }).disposed(by: disposeBag)
        
        tableView.didSelect.subscribe(onNext: { [weak self] item in
            guard let self = self,
                  let profile = self.viewModel.images.value.first
            else { return }
            self.show(ProfilePhotoViewController(self.viewModel.userViewID.value == nil ? .personal : .view,
                                                 profileImage: profile,
                                                 mainImage: self.viewModel.images.value[item],
                                                 name: self.viewModel.nameAge.value ?? ""),
                      sender: nil)
        }).disposed(by: disposeBag)
        
        collectionView.addPhoto.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.view.addSubview(self.mediaOptionPopup)
            self.mediaOptionPopup.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }
        }).disposed(by: disposeBag)
        
        let imagePicker = ImagePicker()
        mediaOptionPopup.didSelect.subscribe(onNext: { [weak self] media in
            self?.mediaOptionPopup.removeFromSuperview()
            switch media {
            case .camera:
                imagePicker.getPermissionCameraImage { image in
                    if let image = image {
                        //upload image here
                        self?.viewModel.uploadImage(image)
                    }
                }
                break
            case .photos:
                imagePicker.getPermissionLibraryImage { image in
                    if let image = image {
                        //upload image here
                        self?.viewModel.uploadImage(image)
                    }
                }
                break
            case .instagram:
                self?.viewModel.getInstagramUsername()
            }
        }).disposed(by: disposeBag)
        
        let instagramPicker = InstagramImagePickerViewController()
        viewModel.showInstagramAuth.subscribe(onNext: { [weak self] show in
            if show {
                self?.show(InstagramAuthViewController({ bool in
                    self?.viewModel.showInstagramAuth.accept(false)
                }), sender: self)
            } else {
                self?.show(instagramPicker, sender: self)
            }
        }).disposed(by: disposeBag)
        
        instagramPicker.collectionView.didSelect.subscribe(onNext: { [weak self] media in
            if let url = media.mediaURL?.absoluteString, let id = media.id {
                self?.viewModel.uploadInstagram(url, sourceID: id)
            }
        }).disposed(by: disposeBag)
        
        collectionView.didSelect.subscribe(onNext: { [weak self] item in
            guard let self = self,
                  let profile = self.viewModel.images.value.first
            else { return }
            self.show(ProfilePhotoViewController(self.viewModel.userViewID.value == nil ? .personal : .view,
                                                 profileImage: profile,
                                                 mainImage: self.viewModel.images.value[item],
                                                 name: self.viewModel.nameAge.value ?? ""),
                      sender: nil)
        }).disposed(by: disposeBag)
        
        viewModel.images.subscribe(onNext: { [weak self] args in
            self?.profileImageView.imageView.kf.setImage(with: URL(string: args.first?.image ?? ""), placeholder: #imageLiteral(resourceName: "profile-placeholder"))
            self?.collectionView.data.accept(args)
            self?.tableView.data.accept(args)
            self?.photoLabel.text = "profile.about.photos".localizedFormat("\(args.count)")
        }).disposed(by: disposeBag)
        
        viewModel.userViewID.subscribe(onNext: { [weak self] userId in
            if userId != nil {
                //avoid add photo
                self?.collectionView.type.accept(.pureView)
            }
        }).disposed(by: disposeBag)
        
    }
    
}
