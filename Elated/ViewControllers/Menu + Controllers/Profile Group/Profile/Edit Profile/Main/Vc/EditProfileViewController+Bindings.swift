//
//  EditProfileViewController+Bindings.swift
//  Elated
//
//  Created by Marlon on 3/25/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxCocoa
import RxSwift
import SafariServices
import SpotifyLogin

extension EditProfileViewController {

    func bindView() {
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)

        viewModel.presentAlert.subscribe(onNext: { [weak self] args in
          let (title, message) = args
          self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        viewModel.quickFacts.bind(to: quickFactsTableView.data).disposed(by: disposeBag)
        
        viewModel.quickFacts.subscribe(onNext: { [weak self] _ in
            self?.quickFactsTableView.reloadData()
            self?.updateQuickFactsTableViewConstraints()
        }).disposed(by: disposeBag)
        
        viewModel.nameAge.bind(to: nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.bio.bind(to: textView.rx.text).disposed(by: disposeBag)
        
        viewModel.likes.bind(to: likesCollectionView.data).disposed(by: disposeBag)
        viewModel.dislikes.bind(to: dislikesCollectionView.data).disposed(by: disposeBag)
        viewModel.images.bind(to: imageCollectionView.data).disposed(by: disposeBag)
    }
    
    func bindEvent() {
        
        quickFactsTableView.selected.subscribe(onNext: { [weak self] index in
            guard let self = self,
                  let section = EditProfileViewModel.QuickFacts(rawValue: index)
            else { return }
            
            let profile = self.viewModel.user.value?.profile
            let location = self.viewModel.user.value?.location
            let matchPref = self.viewModel.user.value?.matchPreferences

            switch section {
            case .birthday:
                let vc = EditProfileBdayViewController(.edit, birthday: profile?.birthdate ?? "")
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: self)
            case .occupation:
                let vc = EditProfileOccupationViewController(.edit, occupation: profile?.occupation ?? "")
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: self)
            case .location:
                let vc = EditProfileLocationViewController(.edit, location: location?.address ?? "")
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: self)
            case .education:
                let vc = EditProfileEducationViewController(.edit, college: profile?.college ?? "")
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: self)
            case .language:
                let vc = EditProfileLanguageViewController(.edit, language: profile?.languages ?? [])
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: self)
            case .religion:
                let vc = EditProfileReligionViewController(.edit, religion: profile?.religionDisplay ?? "")
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: self)
            case .race:
                let raceDisplay = Race(rawValue: profile?.raceDisplay ?? "")?.getName()
                let race = raceDisplay != nil ? raceDisplay ?? "" : profile?.raceDisplay ?? ""
                let vc = EditProfileRaceViewController(.edit, race: race)
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: self)
            case .distance:
                let vc = EditProfileRangeViewController(.edit,
                                                        distanceType: matchPref?.distanceType ?? .miles,
                                                        range: matchPref?.maxDistance ?? 100)
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: self)
            case .ageRange:
                let vc = SettingsAgeViewController(.edit,
                                                   minAge: matchPref?.ageMin ?? 18,
                                                   maxAge: matchPref?.ageMax ?? 30)
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: self)
            case .zodiac:
                let vc = EditProfileZodiacViewController(.edit, zodiac: profile?.zodiac)
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: self)
            case .datingPreference:
                let vc = EditProfileDatePrefViewController(matchPref?.relationshipPref)
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: self)
            case .status:
                let vc = EditProfileStatusViewController(profile?.maritalStatus)
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: self)
            case .gender:
                let vc = EditProfileGenderViewController(.edit,
                                                         gender: profile?.gender,
                                                         isGenderPreference: false)
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: self)
            case .kids:
                let vc = EditProfileHaveKidsViewController(profile?.haveKids)
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: self)
            case .kidPreference:
                let vc = EditProfileWantKidsViewController(matchPref?.familyPref)
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: self)
            case .smokingPreference:
                let vc = EditProfileSmokingViewController()
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: self)
            case .height:
                guard let profile = profile else { return }
                let inches = (profile.heightCm ?? 0) / 2.54
                let vc = EditProfileHeightViewController(.edit, heightIn: inches)
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: self)
            }
        }).disposed(by: disposeBag)
        
        imageCollectionView.addPhoto.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.view.addSubview(self.mediaOptionPopup)
            self.mediaOptionPopup.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }
        }).disposed(by: disposeBag)
        
        imageCollectionView.didDelete.subscribe(onNext: { [weak self] index in
            guard let self = self,
                  let id = self.viewModel.images.value[index].pk
            else { return }
            self.viewModel.deleteImage(id)
        }).disposed(by: disposeBag)
                
        let imagePicker = ImagePicker()
        mediaOptionPopup.didSelect.subscribe(onNext: { [weak self] media in
            self?.mediaOptionPopup.removeFromSuperview()
            switch media {
            case .camera:
                imagePicker.getPermissionCameraImage { image in
                    if let image = image {
                        self?.navigationController?.show(AddImageCaptionViewController(image: image,
                                                                                       urlImage: nil,
                                                                                       sourceID: nil,
                                                                                       editType: .edit),
                                                         sender: self)
                    }
                }
                break
            case .photos:
                imagePicker.getPermissionLibraryImage { image in
                    if let image = image {
                        self?.navigationController?.show(AddImageCaptionViewController(image: image,
                                                                                       urlImage: nil,
                                                                                       sourceID: nil,
                                                                                       editType: .edit),
                                                         sender: self)
                    }
                }
                break
            case .instagram:
                self?.viewModel.getInstagramUsername()
                break
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.show(AddImageCaptionViewController(image: nil,
                                                             urlImage: url,
                                                             sourceID: id,
                                                             editType: .edit),
                               sender: nil)
                }
            }
        }).disposed(by: disposeBag)
        
        textView.rx.didBeginEditing.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.textView.resignFirstResponder()
            self.show(EditProfileBioViewController(.edit, bio: self.viewModel.bio.value), sender: nil)
        }).disposed(by: disposeBag)
        
        likesCollectionView.didRemoveItem.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.viewModel.removeLikes(likes: [self.likesCollectionView.data.value[index].title])
        }).disposed(by: disposeBag)
        
        dislikesCollectionView.didRemoveItem.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.viewModel.removedislikes(likes: [self.dislikesCollectionView.data.value[index].title])
        }).disposed(by: disposeBag)
        
        addBookView.didTap.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.show(EditBooksViewController(.edit), sender: nil)
        }).disposed(by: disposeBag)
        
        addMusicView.didTap.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.show(EditMusicViewController(.edit), sender: nil)
        }).disposed(by: disposeBag)

        viewModel.books.subscribe(onNext: {  [weak self] book in
            guard let self = self else { return }
            self.booksCollectionView.data.accept(book)
            let shouldHide = book.count == 0
            
            self.booksCollectionView.isHidden = shouldHide
            self.booksCollectionView.snp.remakeConstraints { make in
                make.top.equalTo(self.booksStack.snp.bottom).offset(shouldHide ? 0 : 16)
                make.left.right.equalTo(self.dislikesCollectionView)
                make.height.equalTo(shouldHide ? 0 : self.booksCollectionView.requiredHeight)
            }
        }).disposed(by: disposeBag)
        
        viewModel.artists.subscribe(onNext: {  [weak self] artists in
            guard let self = self else { return }
            let data = artists.map { (#imageLiteral(resourceName: "icon-spotify"), $0.images.first?.url, $0.name ?? "", AddDeleteTableViewCell.ButtonType.display) }
            self.spotifyTableView.data.accept(data)
            let shouldHide = artists.count == 0
            
            self.addMusicView.isHidden = !shouldHide

            self.spotifyTableView.isHidden = shouldHide
            self.spotifyTableView.snp.remakeConstraints { make in
                make.top.equalTo(self.spotifyStack.snp.bottom).offset(shouldHide ? 0 : 14)
                make.left.right.equalTo(self.addBookView)
                make.height.equalTo(shouldHide ? 0 : self.spotifyTableView.data.value.count * 70)
                if !shouldHide {
                    make.bottom.equalToSuperview().inset(50)
                }
            }
        }).disposed(by: disposeBag)
        
        
        booksCollectionView.didDelete.subscribe(onNext: { [weak self] index in
            guard let self = self,
                  let id = self.viewModel.books.value[index].id
            else { return }
            self.viewModel.deleteBook(id)
        }).disposed(by: disposeBag)
        
        booksCollectionView.getMoreBooks.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.viewModel.getBooks(initialPage: false)
        }).disposed(by: disposeBag)
        
    }
    
}
