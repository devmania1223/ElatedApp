//
//  CreateProfileAddPhotoViewController.swift
//  Elated
//
//  Created by Marlon on 6/10/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class CreateProfileAddPhotoViewController: BaseViewController {

    let viewModel = CreateProfileAddPhotoViewModel()
    
    internal let imageCollectionView = GalleryCollectionView(.edit)

    private let mediaOptionPopup = MediaOptionPopupView()
    private let mediaOptionMinimumPopup = MediaOptionMinimumPopupView()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "media.option.title".localized
        label.font = .futuraMedium(22)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let keyWindow = UIApplication.shared.connectedScenes
                            .filter({$0.activationState == .foregroundActive})
                            .map({$0 as? UIWindowScene})
                            .compactMap({$0})
                            .first?.windows
                            .filter({$0.isKeyWindow}).first
    
    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    
    private let nextButton = UIButton.createCommonBottomButton("common.next")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar(.elatedPrimaryPurple,
                                font: .futuraMedium(20),
                                tintColor: .elatedPrimaryPurple,
                                backgroundColor: .white,
                                backgroundImage: nil,
                                addBackButton: true)
        self.viewModel.getProfile()
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(84)
            make.left.right.equalToSuperview().inset(50)
        }
        
        view.addSubview(imageCollectionView)
        imageCollectionView.isScrollEnabled = true
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(37)
            make.left.right.equalToSuperview().inset(15)
        }
        
        view.addSubview(bottomBackground)
        bottomBackground.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(imageCollectionView.snp.bottom).offset(12)
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
        
        viewModel.images.bind(to: imageCollectionView.data).disposed(by: disposeBag)
        
        imageCollectionView.addPhoto.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.keyWindow?.addSubview(self.mediaOptionPopup)
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
                        self?.show(AddImageCaptionViewController(image: image, urlImage: nil, sourceID: nil, editType: .onboarding), sender: nil)
                    }
                }
                break
            case .photos:
                imagePicker.getPermissionLibraryImage { image in
                    if let image = image {
                        self?.show(AddImageCaptionViewController(image: image, urlImage: nil, sourceID: nil, editType: .onboarding), sender: nil)
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
                                                             editType: .onboarding),
                               sender: nil)
                }
            }
        }).disposed(by: disposeBag)
        
        nextButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            if self.viewModel.images.value.count > 2 {
                self.viewModel.next.accept(())
            } else {
                self.keyWindow?.addSubview(self.mediaOptionMinimumPopup)
                self.mediaOptionMinimumPopup.snp.remakeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        }.disposed(by: disposeBag)
        
        mediaOptionMinimumPopup.dismiss.subscribe(onNext: { [weak self] in
            self?.mediaOptionMinimumPopup.removeFromSuperview()
        }).disposed(by: disposeBag)

    }
    
}
