//
//  CreateProfilePageViewController.swift
//  Elated
//
//  Created by Marlon on 6/7/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

enum EditInfoControllerType {
    case edit
    case onboarding
    case settings
}

class CreateProfilePageViewController: UIPageViewController {

    let viewModel = CreateProfilePageViewModel()
    
    lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = getViewControllers().count
        control.currentPage = 0
        control.pageIndicatorTintColor = .lavanderFloral
        control.currentPageIndicatorTintColor = .elatedPrimaryPurple
        control.isUserInteractionEnabled = false
        control.isHidden = getViewControllers().count < 1
        return control
    }()
    
    private var viewControllerList = [UIViewController]()

    init(addBooks: Bool, addMusic: Bool) {
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal,
                   options: nil)
        self.viewModel.addBooks.accept(addBooks)
        self.viewModel.addMusic.accept(addMusic)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllerList = self.getViewControllers()
        setViewControllers([self.getViewControllers()[0]], direction: .forward, animated: true, completion: nil)
        initSubviews()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func initSubviews() {
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(Util.heigherThanIphone6 ? 30 : 0)
            make.left.right.equalToSuperview().inset(33)
        }
        
    }
    
    private func bind() {
        
        viewModel.nextPage.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let index = self.pageControl.currentPage + 1
            let list = self.viewControllerList.count - 1
            self.pageControl.isHidden = index == list
            if index <= list {
                self.pageControl.currentPage = index
                self.setViewControllers([self.viewControllerList[index]],
                                        direction: .forward,
                                        animated: true,
                                        completion: nil)
            }
        }).disposed(by: rx.disposeBag)
    
    }
    
    private func getViewControllers() -> [UIViewController] {
        
        var viewControllers = [UIViewController]()
        guard let user = MemCached.shared.userInfo else { return [] }
        
        if let fname = user.firstName,
           let lname = user.lastName,
           fname.isEmpty || lname.isEmpty  {
            let vc = CreateProfileNameViewController()
            vc.viewModel.success.bind(to: viewModel.nextPage).disposed(by: rx.disposeBag)
            viewControllers.append(vc)
        }
        
        if user.profileImages.count < 3 {
            let vc = CreateProfileAddPhotoViewController()
            vc.viewModel.next.bind(to: viewModel.nextPage).disposed(by: rx.disposeBag)
            viewControllers.append(vc)
        }
        
        if user.profile?.gender == nil {
            let vc = EditProfileGenderViewController(.onboarding,
                                                     gender: nil,
                                                     isGenderPreference: false)
            vc.viewModel.success.bind(to: viewModel.nextPage).disposed(by: rx.disposeBag)
            viewControllers.append(vc)
        }
        
        if user.profile?.birthdate == nil || user.profile?.birthdate == "" {
            let vc = EditProfileBdayViewController(.onboarding)
            vc.viewModel.success.bind(to: viewModel.nextPage).disposed(by: rx.disposeBag)
            viewControllers.append(vc)
        }
        
        if user.profile?.heightFeet == nil || user.profile?.heightFeet == "" {
            let vc = EditProfileHeightViewController(.onboarding, heightIn: 60)
            vc.viewModel.success.bind(to: viewModel.nextPage).disposed(by: rx.disposeBag)
            viewControllers.append(vc)
        }
        
        if let property = user.profile?.bio,
           property.isEmpty {
            let vc = EditProfileBioViewController(.onboarding, bio: "")
            vc.viewModel.success.bind(to: viewModel.nextPage).disposed(by: rx.disposeBag)
            viewControllers.append(vc)
        }
        
        if let property = user.profile?.occupation,
           property.isEmpty {
            let vc = EditProfileOccupationViewController(.onboarding, occupation: "")
            vc.viewModel.success.bind(to: viewModel.nextPage).disposed(by: rx.disposeBag)
            viewControllers.append(vc)
        }
        
        if user.profile?.college == nil || user.profile?.college == "" {
            let vc = EditProfileEducationViewController(.onboarding, college: "")
            vc.viewModel.success.bind(to: viewModel.nextPage).disposed(by: rx.disposeBag)
            viewControllers.append(vc)
        }
        
        if let property = user.profile?.languages,
           property.count == 0 {
            let vc = EditProfileLanguageViewController(.onboarding, language: [])
            vc.viewModel.success.bind(to: viewModel.nextPage).disposed(by: rx.disposeBag)
            viewControllers.append(vc)
        }
        
        if (user.profile?.religionDisplay == nil || user.profile?.religionDisplay == "") {
            let vc = EditProfileReligionViewController(.onboarding, religion: "")
            vc.viewModel.success.bind(to: viewModel.nextPage).disposed(by: rx.disposeBag)
            viewControllers.append(vc)
        }
        
        if user.profile?.raceDisplay == nil || user.profile?.raceDisplay == "" {
            let vc = EditProfileRaceViewController(.onboarding, race: "")
            vc.viewModel.success.bind(to: viewModel.nextPage).disposed(by: rx.disposeBag)
            viewControllers.append(vc)
        }
        
        if user.profile?.zodiac == nil {
            let vc = EditProfileZodiacViewController(.onboarding, zodiac: nil)
            vc.viewModel.success.bind(to: viewModel.nextPage).disposed(by: rx.disposeBag)
            viewControllers.append(vc)
        }
        
        if let property = user.location?.address,
           property.isEmpty {
            let vc = EditProfileLocationViewController(.onboarding, location: "")
            vc.viewModel.success.bind(to: viewModel.nextPage).disposed(by: rx.disposeBag)
            viewControllers.append(vc)
        }
        
        if user.matchPreferences?.genderPref == nil {
            let vc = EditProfileGenderViewController(.onboarding,
                                                     gender: nil,
                                                     isGenderPreference: true)
            vc.viewModel.success.bind(to: viewModel.nextPage).disposed(by: rx.disposeBag)
            viewControllers.append(vc)
        }
        
        if user.matchPreferences?.ageMax == 0
           || user.matchPreferences?.ageMin == 0 {
            let vc = SettingsAgeViewController(.onboarding, minAge: 18, maxAge: 35)
            vc.viewModel.success.bind(to: viewModel.nextPage).disposed(by: rx.disposeBag)
            viewControllers.append(vc)
        }
        
        if user.matchPreferences?.maxDistance == 50
            || user.matchPreferences?.maxDistance == nil { //50 is the default value
            let vc = EditProfileRangeViewController(.onboarding, distanceType: .miles, range: 10)
            vc.viewModel.success.bind(to: viewModel.nextPage).disposed(by: rx.disposeBag)
            viewControllers.append(vc)
        }
        
        if user.matchPreferences?.locationType == nil {
            let vc = SettingsLocationViewController(type: .onboarding,
                                                    location: .nearMe,
                                                    address: "", zipCode: "")
            vc.viewModel.success.bind(to: viewModel.nextPage).disposed(by: rx.disposeBag)
            viewControllers.append(vc)
        }
        
        if viewModel.addBooks.value {
            let vc = EditBooksViewController(.onboarding)
            vc.viewModel.success.bind(to: self.viewModel.nextPage).disposed(by: self.rx.disposeBag)
            viewControllers.append(vc)
        }
        
        //if viewModel.addMusic.value {
            let vc = EditMusicViewController(.onboarding)
            vc.viewModel.success.bind(to: self.viewModel.nextPage).disposed(by: self.rx.disposeBag)
            viewControllers.append(vc)
        //}
        
        viewControllers.append(CreatingProfileViewController())
        
        return viewControllers
        
    }
    
}


