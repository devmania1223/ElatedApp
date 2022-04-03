//
//  BashoTutorialGameViewController.swift
//  Elated
//
//  Created by Rey Felipe on 9/18/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import AMPopTip
import DragDropiOS
import IQKeyboardManagerSwift
import Lottie
import SwiftyJSON

class BashoTutorialGameViewController: BaseViewController {
    
    enum InstructionTag: Int {
        case timer
        case toolbar
        case wordSuggestion
        case dictionary
        case searchWord
        case searchDragDrop
        case syllableCount
        case chooseSyllableCount
        case syllableDragDrop
        case done
        
        func next() -> InstructionTag {
            switch self {
            case .timer:
                return .toolbar
            case .toolbar:
                return .wordSuggestion
            case .wordSuggestion:
                return .dictionary
            case .dictionary:
                return .searchWord
            case .searchWord:
                return .searchDragDrop
            case .searchDragDrop:
                return .syllableCount
            case .syllableCount:
                return .chooseSyllableCount
            case .chooseSyllableCount:
                return .syllableDragDrop
            case .syllableDragDrop, .done:
                return .done
            }
        }
    }
    private var instruction: InstructionTag = InstructionTag.timer
    
    internal let viewModel = BashoGameViewModel()
        
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
        
        view.addSubview(bashoCollectionPlaceholderLabel)
        bashoCollectionPlaceholderLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.left.equalTo(profileImageView.snp.right).offset(16)
            make.right.bottom.equalToSuperview().inset(16)
        }
        
        return view
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
        button.isUserInteractionEnabled = false
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
        label.text = "15"
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
    
    internal let bashoCollectionPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .sonicSilver
        label.text = "basho.words.tip".localized
        label.font = .futuraBook(14)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    internal let syllablesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .futuraBook(12)
        return label
    }()
    
    private let instructionBGView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.opacity = 0
        return view
    }()
    
    private let animationDragAndDropView: AnimationView = {
        let animation = AnimationView(name: "word-drag-and-drop")
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.backgroundBehavior = .pauseAndRestore
        animation.isHidden = true
        return animation
    }()
    
    internal let nextButton = UIButton.createCommonBottomButton("common.next")
    private var keyboardHeight: CGFloat = 216.0
    private var keyboardOverlayView = UIView()
    private var popTip = PopTip()
    
    var completionHandler: (() -> Void)?
    
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
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
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
        
        timer.fire()
        
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
        addInstructionGradientLayer()
        showInstructionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        super.viewWillDisappear(animated)
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
        
        view.addSubview(animationDragAndDropView)
        animationDragAndDropView.snp.makeConstraints { make in
            make.height.width.equalTo(320)
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(alphabeticalCollectionView.snp.top).offset(-116)
        }
        
        view.addSubview(syllableView)
        syllableView.snp.makeConstraints { make in
            make.bottom.equalTo(self.textInputView.snp.top).offset(-12)
            make.left.equalToSuperview().offset(24)
        }
        
        view.addSubview(instructionBGView)
        instructionBGView.snp.makeConstraints { make in
            make.top.bottom.width.height.equalToSuperview()
        }
        
        instructionBGView.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(33)
            make.bottom.equalToSuperview().offset(-25)
        }
    }
    
    override func bind() {
        super.bind()
        
        nextButton.rx.tap.bind { [weak self] in
            if self?.instruction != .done {
                self?.nextInstruction()
            } else {
                self?.navigationController?.popViewController(animated: false)
                self?.completionHandler?()
            }
        }.disposed(by: disposeBag)
        
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
    
    @objc internal func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
        }
    }
    
    @objc internal func keyboardDidShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.suggestionCollectionView.isHidden = false
                self.treeView.isHidden = true
                self.alphabeticalCollectionView.isHidden = true
                self.textInputView.becomeFirstResponder()
                self.view.bringSubviewToFront(self.suggestionCollectionView)
                
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

            self.textInputView.snp.updateConstraints { make in
                make.bottom.equalToSuperview()
            }
        }
    }
    
    internal func manageDictionary(_ show: Bool, definition: BashoWordDefinition?) {
        self.dictionaryView.definition.accept(definition)
        view.bringSubviewToFront(dictionaryView)
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

//MARK: - Tooltip
extension BashoTutorialGameViewController {
    
    private func showInstructionView() {
        instructionBGView.fadeTransition(0.1)
        view.bringSubviewToFront(instructionBGView)
        instructionBGView.layer.opacity = 1
        
        switch instruction {
        case .timer:
            IQKeyboardManager.shared.shouldResignOnTouchOutside = false
            syllableView.isHidden = true
            view.bringSubviewToFront(circleOuter)
            popTip = initPopTip()
            popTip.show(text: "tooltip.basho.instruction.timer".localized,
                        direction: .down,
                        maxWidth: 275,
                        in: view,
                        from: circleOuter.frame)
            view.bringSubviewToFront(popTip)
            attachKeyboardOverlay()
        case .toolbar:
            view.bringSubviewToFront(bashoCollectionDroppableView)
            view.bringSubviewToFront(textInputView)
            popTip = initPopTip()
            popTip.offset = 10
            popTip.show(text: "tooltip.basho.instruction.toolbar".localized,
                        direction: .up,
                        maxWidth: 275,
                        in: view,
                        from: textInputView.frame)
            view.bringSubviewToFront(popTip)
            attachKeyboardOverlay()
        case .wordSuggestion:
            view.bringSubviewToFront(suggestionCollectionView)
            view.bringSubviewToFront(textInputView)
            popTip = initPopTip(dimissable: true)
            popTip.offset = 5
            popTip.show(text: "tooltip.basho.instruction.word.suggestion".localized,
                        direction: .up,
                        maxWidth: 200,
                        in: view,
                        from: suggestionCollectionView.frame,
                        duration: 2.5)
            view.bringSubviewToFront(popTip)
            attachKeyboardOverlay()
        case .dictionary:
            view.bringSubviewToFront(suggestionCollectionView)
            popTip = initPopTip(dimissable: true)
            popTip.offset = 5
            popTip.show(text: "tooltip.basho.instruction.dictionary".localized,
                        direction: .up,
                        maxWidth: 200,
                        in: view,
                        from: suggestionCollectionView.frame,
                        duration: 2.5)
            view.bringSubviewToFront(popTip)
            attachKeyboardOverlay()
        case .searchWord:
            view.bringSubviewToFront(textInputView)
            popTip = initPopTip()
            popTip.offset = Util.heigherThanIphone6 ? 35 : 15
            popTip.show(text: "tooltip.basho.instruction.search.word".localized,
                        direction: .up,
                        maxWidth: 200,
                        in: textInputView,
                        from: textInputView.searchButton.frame)
            view.bringSubviewToFront(popTip)
            attachKeyboardOverlay()
        case .searchDragDrop:
            view.bringSubviewToFront(bashoCollectionDroppableView)
            view.bringSubviewToFront(alphabeticalCollectionView)
            animationDragAndDropView.isHidden = false
            animationDragAndDropView.play()
            popTip = initPopTip(dimissable: true, darkmode: true)
            popTip.show(text: "tooltip.basho.instruction.drag.drop".localized,
                        direction: Util.heigherThanIphone6 ? .down : .up,
                        maxWidth: 200,
                        in: view,
                        from: Util.heigherThanIphone6 ? animationDragAndDropView.frame : alphabeticalCollectionView.frame,
                        duration: 6.0)
            popTip.dismissHandler = { [weak self] popTip in
                guard let self = self else { return }
                self.animationDragAndDropView.stop()
                self.animationDragAndDropView.isHidden = true
            }
            view.bringSubviewToFront(popTip)
            view.bringSubviewToFront(animationDragAndDropView)
        case .syllableCount:
            view.bringSubviewToFront(textInputView)
            popTip = initPopTip()
            popTip.offset = Util.heigherThanIphone6 ? 35 : 15
            popTip.show(text: "tooltip.basho.instruction.syllable.count".localized,
                        direction: .up,
                        maxWidth: 200,
                        in: textInputView,
                        from: textInputView.sylableButton.frame)
            view.bringSubviewToFront(popTip)
            attachKeyboardOverlay()
        case .chooseSyllableCount:
            syllableView.isHidden = false
            view.bringSubviewToFront(bashoCollectionDroppableView)
            view.bringSubviewToFront(syllableView)
            syllableView.manageValues()
            popTip = initPopTip(dimissable: true)
            popTip.show(text: "tooltip.basho.instruction.choose.syllable.count".localized,
                        direction: .up,
                        maxWidth: 200,
                        in: syllableView,
                        from: syllableView.syllableButton3.frame,
                        duration: 2.5)
            view.bringSubviewToFront(popTip)
        case .syllableDragDrop:
            syllableView.isHidden = false
            view.bringSubviewToFront(bashoCollectionDroppableView)
            view.bringSubviewToFront(treeView)
            view.bringSubviewToFront(syllableView)
            animationDragAndDropView.snp.updateConstraints { make in
                make.left.equalToSuperview().offset(52)
                make.top.equalTo(alphabeticalCollectionView.snp.top).offset(-155)
            }
            animationDragAndDropView.isHidden = false
            animationDragAndDropView.play()
            popTip = initPopTip(dimissable: true, darkmode: true)
            popTip.show(text: "tooltip.basho.instruction.drag.drop".localized,
                        direction: Util.heigherThanIphone6 ? .down : .up,
                        maxWidth: 200,
                        in: view,
                        from: Util.heigherThanIphone6 ? animationDragAndDropView.frame : treeView.frame,
                        duration: 6.0)
            popTip.dismissHandler = { [weak self] popTip in
                guard let self = self else { return }
                self.animationDragAndDropView.stop()
                self.animationDragAndDropView.isHidden = true
            }
            view.bringSubviewToFront(popTip)
            view.bringSubviewToFront(animationDragAndDropView)
        case .done:
            popTip = initPopTip(dimissable: true, darkmode: true)
            popTip.show(text: "tooltip.common.instruction.play".localized,
                        direction: .up,
                        maxWidth: 200,
                        in: view,
                        from: nextButton.frame,
                        duration: 2.5)
            view.bringSubviewToFront(popTip)
            return
        }
        
    }
    
    private func nextInstruction() {
        instructionBGView.fadeTransition(0.1)
        instructionBGView.layer.opacity = 0
        popTip.hide()
        detachKeyboardOverlay()
        instruction = instruction.next()
        
        switch instruction {
        case .timer:
            break
        case .toolbar:
            textInputView.sendButton.isUserInteractionEnabled = false
            textInputView.sylableButton.isUserInteractionEnabled = false
            textInputView.searchButton.isUserInteractionEnabled = false
        case .wordSuggestion:
            suggestionCollectionView.isUserInteractionEnabled = false
            showSuggestedWord("Wa")
        case .dictionary:
            suggestionCollectionView.isUserInteractionEnabled = true
        case .searchWord:
            suggestionCollectionView.isUserInteractionEnabled = false
            showSuggestedWord("")
            textInputView.searchButton.isSelected = true
            dictionaryView.isHidden = true
        case .searchDragDrop:
            viewModel.visibleWordOption.accept(.alphabetical)
        case .syllableCount:
            animationDragAndDropView.isHidden = true
            animationDragAndDropView.stop()
            textInputView.textField.becomeFirstResponder()
            viewModel.visibleWordOption.accept(nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
                self.textInputView.sylableButton.isSelected = true
                self.showInstructionView()
            }
            return
        case .chooseSyllableCount:
            viewModel.visibleWordOption.accept(.tree)
            treeView.isUserInteractionEnabled = false
        case .syllableDragDrop:
            treeView.isUserInteractionEnabled = true
        case .done:
            animationDragAndDropView.isHidden = true
            animationDragAndDropView.stop()
            nextButton.setTitle("common.play".localized, for: .normal)
            viewModel.visibleWordOption.accept(nil)
        }
        
        showInstructionView()
    }
    
    private func attachKeyboardOverlay() {
        // Calculate and replace the frame according to your keyboard frame
        keyboardOverlayView = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height-keyboardHeight, width: self.view.frame.size.width, height: keyboardHeight))
        keyboardOverlayView.backgroundColor = .clear
        keyboardOverlayView.layer.zPosition = CGFloat(MAXFLOAT)
        
        let backGroundView = UIView()
        backGroundView.backgroundColor = .elatedSecondaryPurple
        backGroundView.layer.opacity = 0.5
        keyboardOverlayView.addSubview(backGroundView)
        backGroundView.snp.makeConstraints { make in
            make.top.bottom.width.height.equalToSuperview()
        }
        
        let nextButton = UIButton.createCommonBottomButton("common.next")
        keyboardOverlayView.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(33)
            make.bottom.equalToSuperview().offset(-25)
        }
        
        nextButton.rx.tap.bind { [weak self] in
            self?.nextInstruction()
        }.disposed(by: disposeBag)
        
        let windowCount = UIApplication.shared.windows.count
        UIApplication.shared.windows[windowCount-1].addSubview(keyboardOverlayView)
    }
    
    private func detachKeyboardOverlay() {
        keyboardOverlayView.removeFromSuperview()
    }
    
    private func initPopTip(dimissable: Bool = false, darkmode: Bool = false) -> PopTip {
        let popTip = PopTip()
        popTip.bubbleColor = darkmode ? .elatedPrimaryPurple : .white
        popTip.textColor = darkmode ? .white : .elatedPrimaryPurple
        popTip.padding = 10
        popTip.edgeMargin = 10
        popTip.shouldDismissOnTap = dimissable
        popTip.shouldDismissOnTapOutside = dimissable
        popTip.shouldDismissOnSwipeOutside = dimissable
        popTip.font = .futuraLight(12)
        return popTip
    }
    
    private func showSuggestedWord(_ word: String) {
        textInputView.textField.text = word
        viewModel.suggestions.accept(CommonWords().getBashoSuggestion(word: word))
    }
    
    private func addInstructionGradientLayer() {
        let colorTop =  UIColor.elatedSecondaryPurple.cgColor
        let colorBottom = UIColor.white.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = instructionBGView.bounds
        gradientLayer.opacity = 0.75
        instructionBGView.layer.insertSublayer(gradientLayer, at:0)
        instructionBGView.bringSubviewToFront(nextButton)
    }
}
