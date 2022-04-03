//
//  BashoGameViewController.swift
//  Elated
//
//  Created by Marlon on 4/14/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON
import DragDropiOS

class BashoGameViewController: BaseViewController {
    
    internal let viewModel = BashoGameViewModel()
    
    internal var reviewer: ReviewerSparkFlirtHistory
    
    var dragDropManager: DragDropManager!
    
    internal let treeView = BashoTreeView()
    
    lazy var suggestionCollectionView: DragDropCollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.itemSize = CGSize(width: 100, height: 30)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        let view = DragDropCollectionView(frame: CGRect(x: 0, y: 0, width: 200, height: 200),
                                          collectionViewLayout: flowLayout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.isScrollEnabled = true
        view.register(BashoSuggestionDragDropCollectionCell.self,
                      forCellWithReuseIdentifier: BashoSuggestionDragDropCollectionCell.identifier)
        
        let provider  = BashoSuggestionsDataProvider(view, viewModel: viewModel)
        view.dragDropDelegate = provider
        view.delegate = provider
        view.dataSource = provider
    
        return view
    }()
    
    lazy var alphabeticalCollectionView: DragDropCollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.itemSize = CGSize(width: 100, height: 30)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        let view = DragDropCollectionView(frame: CGRect(x: 0, y: 0, width: 200, height: 200),
                                          collectionViewLayout: flowLayout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.isScrollEnabled = true
        view.register(BashoSuggestionDragDropCollectionCell.self,
                      forCellWithReuseIdentifier: BashoSuggestionDragDropCollectionCell.identifier)
        view.register(BashoAlphabeticalCollectionHeader.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: BashoAlphabeticalCollectionHeader.identifier)
        
        let provider  = BashoAlphabeticalDataProvider(view, viewModel: viewModel)
        view.dragDropDelegate = provider
        view.delegate = provider
        view.dataSource = provider
        return view
    }()
    
    internal let bashoCollectionView: CommonCollectionView = {
        let view = CommonCollectionView([],
                                        isEdit: true,
                                        selectionType: .none,
                                        scrollDirection: .vertical,
                                        theme: CommonCollectionView.Theme(borderColor: .white,
                                                                          borderWidth: 0,
                                                                          backgroundColor: .white,
                                                                          textColor: .elatedPrimaryPurple))
        view.editImage = #imageLiteral(resourceName: "close_white").withTintColor(.lightGray)
        view.editButtonWidth = 12
        view.backgroundColor = .clear
        view.isScrollEnabled = true
        return view
    }()
    
    internal lazy var bashoCollectionDroppableView: BashoDropableView = {
        let view = BashoDropableView(viewModel: viewModel)
        view.backgroundColor = .palePurplePantone
        view.layer.cornerRadius = 10
    
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.left.equalTo(16)
            make.width.height.equalTo(45)
        }
        
        view.addSubview(bashoCollectionView)
        bashoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(1)
        }
        
        return view
    }()
    
    internal lazy var alertBubble: AlertBubble = {
        let alert = AlertBubble(.bottomLeft,
                                text: "basho.dictionary.tip".localized,
                                color: .white,
                                textColor: .elatedPrimaryPurple)
        alert.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideTip)))
        return alert
    }()
    
    internal let dictionaryView = BashoDictionaryView()
    
    internal let textInputView = BashoKeyboardAccessoryView()

    internal lazy var timer = Timer.scheduledTimer(timeInterval: 1,
                                                  target: self,
                                                  selector: #selector(countDown),
                                                  userInfo: nil,
                                                  repeats: true)
    
    internal var tipTimer: Timer?

    internal let lockImageView = UIImageView(image:#imageLiteral(resourceName: "asset-75px-chat-locked-0"))
    private let titleImageView = UIImageView(image: #imageLiteral(resourceName: "logo-basho"))

    internal let syllableView = BashoSyllableView()

    internal let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-gear-white"), for: .normal)
        return button
    }()
    
    private let circleOuter: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lavanderFloral.withAlphaComponent(0.5)
        view.layer.cornerRadius = 40
        return view
    }()
    
    private let circleInner: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        return view
    }()
    
    internal let timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkOrchid
        label.font = .futuraMedium(24)
        label.textAlignment = .center
        return label
    }()
    
    internal lazy var profileImageView: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "Oval_fill"))
        view.layer.cornerRadius = 22.5
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        if let image = MemCached.shared.userInfo?.profileImages.first?.image {
            view.kf.setImage(with: URL(string: image))
        }
        return view
    }()
    
    internal let syllablesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .futuraBook(12)
        return label
    }()
    
    internal let keyWindow = UIApplication.shared.connectedScenes
                                .filter({$0.activationState == .foregroundActive})
                                .map({$0 as? UIWindowScene})
                                .compactMap({$0})
                                .first?.windows
                                .filter({$0.isKeyWindow}).first
    
    internal lazy var timesUpView = BashoTimesUpPopup(frame: keyWindow!.frame)
    internal lazy var settingsView = BashoMenuSettingPopup(frame: keyWindow!.frame)
    internal lazy var skipView = BashoSkipPopup(frame: keyWindow!.frame)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    init(_ detail: BashoGameDetail) {
        
        //initialize reviewer
        let otherUser = MemCached.shared.isSelf(id: detail.invitee?.id)
                  ? detail.invitee?.id
                  : detail.inviter?.id
        reviewer = ReviewerSparkFlirtHistory(otherUserID: otherUser!)
        reviewer.gameDetail.accept(detail)
        
        super.init(nibName: nil, bundle: nil)

        viewModel.detail.accept(detail)
        let lines =  detail.basho.count + 1 > 3 ? 2 : detail.basho.count + 1
        viewModel.haikuLine.accept(HaikuLine(rawValue: lines)!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hideNavBar()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidShow),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        textInputView.textField.becomeFirstResponder()
        
        tipTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(hideTip), userInfo: nil, repeats: false)
        
        //sample
        let dict = CommonWords().getCommonBashoDictionary()
        let index: Int = Int(arc4random_uniform(UInt32(dict.count)))
        let words = Array(dict.values)[index]
        treeView.suggestedWords.accept(words)
        
        self.initDragableDropable()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer.fire()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        timer.invalidate()
        tipTimer?.invalidate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        textInputView.layoutIfNeeded()
    }
    
    internal func initDragableDropable() {
        var items: [UIView] = [UIView]()
        items.append(contentsOf: treeView.treeItems.value)
        items.append(suggestionCollectionView)
        items.append(bashoCollectionView)
        items.append(bashoCollectionDroppableView)
        items.append(alphabeticalCollectionView)
        dragDropManager = DragDropManager(canvas: self.view,
                                          views: items)
    }
    
    override func initSubviews() {
        super.initSubviews()
            
        view.addSubview(suggestionCollectionView)
        view.addSubview(alphabeticalCollectionView)
        view.addSubview(alertBubble)

        let bg = UIImageView(image: #imageLiteral(resourceName: "Basho BG"))
        view.addSubview(bg)
        bg.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(-2)
            make.right.equalToSuperview().offset(2)
        }
    
        view.addSubview(textInputView)
        textInputView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
        }
        
        view.addSubview(lockImageView)
        lockImageView.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(8)
            make.width.height.equalTo(40)
        }
        
        view.addSubview(titleImageView)
        titleImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(lockImageView)
            make.width.equalTo(90)
            make.height.equalTo(25)
        }
        
        view.addSubview(settingsButton)
        settingsButton.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.centerY.equalTo(lockImageView)
            make.width.height.equalTo(24)
        }
        
        view.addSubview(circleOuter)
        circleOuter.snp.makeConstraints { make in
            make.top.equalTo(titleImageView.snp.bottom).offset(23)
            make.centerX.equalTo(titleImageView)
            make.width.height.equalTo(80)
        }
        
        circleOuter.addSubview(circleInner)
        circleInner.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        circleInner.addSubview(timerLabel)
        timerLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        view.addSubview(bashoCollectionDroppableView)
        bashoCollectionDroppableView.snp.makeConstraints { make in
            make.top.equalTo(circleOuter.snp.bottom).offset(22)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(105)
        }
        
        view.addSubview(syllablesLabel)
        syllablesLabel.snp.makeConstraints { make in
            make.top.equalTo(bashoCollectionDroppableView.snp.bottom).offset(12)
            make.right.equalTo(bashoCollectionDroppableView)
        }
        
        view.addSubview(dictionaryView)
        dictionaryView.isHidden = true
        dictionaryView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(UIDevice.current.hasTopNotch ? 250 : 175)
        }
        
        view.addSubview(treeView)
        treeView.snp.makeConstraints { make in
            make.top.equalTo(syllablesLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(textInputView.snp.top)
        }
        treeView.isHidden = true
        view.bringSubviewToFront(treeView)
        
        view.addSubview(alphabeticalCollectionView)
        alphabeticalCollectionView.snp.makeConstraints { make in
            make.top.equalTo(syllablesLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(textInputView.snp.top)
        }
        view.bringSubviewToFront(alphabeticalCollectionView)
        
        suggestionCollectionView.snp.makeConstraints { make in
            make.bottom.equalTo(textInputView.snp.top).offset(-8)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        alertBubble.snp.makeConstraints { make in
            make.bottom.equalTo(self.suggestionCollectionView.snp.top).offset(-10)
            make.left.right.equalToSuperview().inset(10)
        }
        
        view.addSubview(syllableView)
        syllableView.snp.makeConstraints { make in
            make.bottom.equalTo(self.textInputView.snp.top).offset(-12)
            make.left.equalToSuperview().offset(24)
        }
        
    }
    
    override func bind() {
        bindView()
        bindEvents()
    }
    
    @objc internal func countDown() {
        var time = viewModel.currentTime.value
        time -= 1
        if time == 0 {
            self.timer.invalidate()
        }
        
        viewModel.currentTime.accept(time)
    }
    
    @objc internal func keyboardDidShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.suggestionCollectionView.isHidden = false
                self.alertBubble.isHidden = self.viewModel.tipShowed.value || self.viewModel.suggestions.value.count == 0
                self.treeView.isHidden = true
                self.alphabeticalCollectionView.isHidden = true
                self.textInputView.becomeFirstResponder()
                self.view.bringSubviewToFront(self.suggestionCollectionView)
                self.view.bringSubviewToFront(self.alertBubble)
                
                self.viewModel.visibleWordOption.accept(nil)
                
                self.textInputView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().inset(keyboardHeight)
                }
            }
            
        }
    }
    
    @objc internal func keyboardWillHide(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.suggestionCollectionView.isHidden = true
            //self.alphabeticalCollectionView.isHidden = true
            self.alertBubble.isHidden = true

            self.textInputView.snp.updateConstraints { make in
                make.bottom.equalToSuperview()
            }
        }
    }
    
    internal func manageDictionary(_ show: Bool, definition: BashoWordDefinition?) {
        self.dictionaryView.definition.accept(definition)
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.dictionaryView.snp.updateConstraints { make in
                make.height.equalTo(show ? (UIDevice.current.hasTopNotch ? 250 : 175) : 0)
            }
        } completion: { [weak self] _ in
            self?.dictionaryView.isHidden = !show
        }
        self.view.layoutIfNeeded()
    }
    
    @objc private func hideTip() {
        viewModel.tipShowed.accept(true)
    }
            
}
