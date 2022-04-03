//
//  StoryShareTutorialGameViewController.swift
//  Elated
//
//  Created by Rey Felipe on 11/19/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import AMPopTip
import IQKeyboardManagerSwift
import SwiftyJSON

class StoryShareTutorialGameViewController: BaseViewController {
    
    enum InstructionTag: Int {
        case invited
        case dictionary
        case enter
        case period
        case done
        
        func next() -> InstructionTag {
            switch self {
            case .invited:
                return .dictionary
            case .dictionary:
                return .enter
            case .enter:
                return .period
            case .period, .done:
                return .done
            }
        }
    }
    private var instruction: InstructionTag = InstructionTag.invited

    internal let viewModel = StoryShareGameViewModel()
    
    internal let dictionaryView: BashoDictionaryView = {
        let view = BashoDictionaryView()
        view.bgView.backgroundColor = .white
        return view
    }()
    
    internal lazy var alertBubble: StoryShareTurnBubble = {
        let alert = StoryShareTurnBubble(dismissable: true)
        alert.isHidden = true // hide this it is not needed on the tutorial
        return alert
    }()

    internal let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-back").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .chestnut
        return button
    }()
    
    internal let periodButton: UIButton = {
        let button = UIButton()
        button.setTitle("storyshare.period".localized, for: .normal)
        button.setTitleColor(.umber, for: .normal)
        button.titleLabel?.font = .courierPrimeRegular(14)
        button.cornerRadius = 25
        button.backgroundColor = .white
        return button
    }()
    
    internal let enterButton: UIButton = {
        let button = UIButton()
        button.setTitle("storyshare.enter".localized, for: .normal)
        button.setTitleColor(.umber, for: .normal)
        button.titleLabel?.font = .courierPrimeRegular(14)
        button.cornerRadius = 25
        button.backgroundColor = .white
        return button
    }()
    
    internal lazy var invisibleTextField: UITextField = {
        let textField = UITextField()
        //textField.isUserInteractionEnabled = false
        textField.alpha = 0
        textField.autocorrectionType = .no
        textField.enablesReturnKeyAutomatically = false
        textField.delegate = self
        return textField
    }()
    
    private let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "background-storyshare"))
    
    private let typeWriterImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "asset-storyshare-typewriter-menu"))
        imageView.contentMode = .top
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .chestnut
        label.font = .courierPrimeRegular(20)
        label.text = "storyshare.title".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    internal let storyTextView: UITextView = {
        let textView = UITextView()
        textView.font = .courierPrimeBold(12)
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isSelectable = false
        textView.backgroundColor = .clear
        textView.spellCheckingType = .yes
        return textView
    }()
    
    internal let colorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .umber
        label.font = .courierPrimeRegular(12)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let reminderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .umber
        label.font = .courierPrimeRegular(12)
        label.text = "storyshare.phrase.reminder".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    internal let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-gear-white").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .chestnut
        return button
    }()
    
    internal let keyWindow = UIApplication.shared.connectedScenes
                                .filter({$0.activationState == .foregroundActive})
                                .map({$0 as? UIWindowScene})
                                .compactMap({$0})
                                .first?.windows
                                .filter({$0.isKeyWindow}).first
    
    internal lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [periodButton, enterButton])
        stackView.axis = .horizontal
        stackView.spacing = 12
        return stackView
    }()
    
    internal lazy var settingsView = EmojiGoStoryShareSettingsPopup(theme: .chestnut)
    
    private let instructionBGView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.opacity = 0
        return view
    }()
    
    internal let nextButton: UIButton = {
        let button = UIButton.createCommonBottomButton("common.next")
        button.backgroundColor = .umber
        return button
    }()
    
    private let typeHereInstructionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .umber
        label.font = .courierPrimeBold(12)
        label.text = "storyshare.type.here".localized
        label.textAlignment = .left
        label.isHidden = true
        label.layer.cornerRadius = 15
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.white.cgColor
        label.clipsToBounds = true
        label.backgroundColor = .white
        return label
    }()
    
    private let storyTextBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.isHidden = true
        return view
    }()
    
    private var popTip = PopTip()
    var completionHandler: (() -> Void)?
    
    init(_ detail: StoryShareGameDetail, isFromLineView: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        viewModel.detail.accept(detail)
        viewModel.isFromLineView = isFromLineView
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
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnTextView(_:)))
        storyTextView.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //REY: No need to show keyboard in tutorial screen
//        invisibleTextField.becomeFirstResponder()
        
        addInstructionGradientLayer()
        showInstructionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        invisibleTextField.resignFirstResponder()
    }
    
    override func initSubviews() {
        super.initSubviews()
            
        //at the back
        view.addSubview(invisibleTextField)

        view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(-2)
            make.right.equalToSuperview().offset(2)
        }
    
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(19)
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(25)
        }
        
        view.addSubview(colorLabel)
        colorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(33)
        }
        
        view.addSubview(reminderLabel)
        reminderLabel.snp.makeConstraints { make in
            make.top.equalTo(colorLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(33)
        }
        
        view.addSubview(alertBubble)
        alertBubble.snp.makeConstraints { make in
            make.top.equalTo(reminderLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(settingsButton)
        settingsButton.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(24)
        }
        
        view.addSubview(typeWriterImage)
        typeWriterImage.snp.makeConstraints { make in
            make.top.equalTo(alertBubble.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
        
        view.addSubview(typeHereInstructionLabel)
        typeHereInstructionLabel.snp.makeConstraints { make in
            make.top.equalTo(typeWriterImage).inset(20)
            make.left.right.equalTo(typeWriterImage).inset(UIScreen.main.bounds.width * 0.15)
            make.height.equalTo(50)
        }
        
        view.addSubview(storyTextView)
        storyTextView.snp.makeConstraints { make in
            make.top.equalTo(typeWriterImage).inset(20)
            make.left.right.equalTo(typeWriterImage).inset(UIScreen.main.bounds.width * 0.15)
            make.bottom.equalTo(typeWriterImage.snp.centerY).offset(-57)
        }
        
        view.addSubview(storyTextBackgroundView)
        storyTextBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(typeWriterImage).inset(10)
            make.left.right.equalTo(typeWriterImage).inset(UIScreen.main.bounds.width * 0.10)
            make.bottom.equalTo(typeWriterImage.snp.centerY).offset(-57)
        }
        
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(typeWriterImage.snp.centerY).inset(40)
        }
        
        periodButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(120)
        }
        
        enterButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(120)
        }
            
        view.addSubview(dictionaryView)
        dictionaryView.isHidden = true
        dictionaryView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(UIDevice.current.hasTopNotch ? 250 : 175)
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
            make.bottom.equalToSuperview().offset(-28)
        }
        
    }
    
    override func bind() {
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
    
    @objc internal func keyboardDidShow(_ notification: Notification) {
//        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRectangle.height
//
//            DispatchQueue.main.async { [weak self] in
//                guard let self = self else { return }
//                self.alertBubble.isHidden = true
//
//                self.buttonStackView.snp.updateConstraints { make in
//                    make.bottom.equalToSuperview().inset(keyboardHeight + 12)
//                }
//            }
//
//        }
    }
    
    @objc internal func keyboardWillHide(_ notification: Notification) {
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            self.alertBubble.isHidden = false
//
//            self.buttonStackView.snp.updateConstraints { make in
//                make.bottom.equalToSuperview().inset(30)
//            }
//        }
    }
    
    internal func manageDictionary(_ show: Bool, definition: BashoWordDefinition?) {
        guard dictionaryView.isUserInteractionEnabled else { return }
        
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
    
    @objc private final func tapOnTextView(_ tapGesture: UITapGestureRecognizer){
        //REY: No need to show keyboard in tutorial screen
//        if MemCached.shared.isSelf(id: viewModel.detail.value?.currentPlayerTurn) {
//            //make sure this is always active
//            self.invisibleTextField.becomeFirstResponder()
//        }
        let point = tapGesture.location(in: storyTextView)
        if let detectedWord = getWordAtPosition(point) {
              self.viewModel.getDefinition(detectedWord)
        }
    }
    
    private final func getWordAtPosition(_ point: CGPoint) -> String? {
        if let textPosition = storyTextView.closestPosition(to: point) {
            if let range = storyTextView.tokenizer.rangeEnclosingPosition(textPosition, with: .word, inDirection: UITextDirection(rawValue: 1)) {
                return storyTextView.text(in: range)
            }
        }
        return nil
    }
    
}


extension StoryShareTutorialGameViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
    
}

//MARK: - Tooltip
extension StoryShareTutorialGameViewController {
    
    private func showInstructionView() {
        instructionBGView.fadeTransition(0.1)
        view.bringSubviewToFront(instructionBGView)
        instructionBGView.layer.opacity = 1
        
        switch instruction {
        case .invited:
            view.bringSubviewToFront(typeHereInstructionLabel)
            typeHereInstructionLabel.isHidden = false
            popTip = initPopTip()
            popTip.offset = 5
            popTip.show(text: "tooltip.storyshare.instruction.invited".localized,
                        direction: .down,
                        maxWidth: 250,
                        in: view,
                        from: typeHereInstructionLabel.frame)
            view.bringSubviewToFront(popTip)
            break
        case .dictionary:
            view.bringSubviewToFront(storyTextBackgroundView)
            storyTextBackgroundView.isHidden = false
            view.bringSubviewToFront(storyTextView)
            view.bringSubviewToFront(dictionaryView)
            popTip = initPopTip(dismissable: true)
            popTip.offset = 10
            popTip.show(text: "tooltip.storyshare.instruction.dictionary".localized,
                        direction: .up,
                        maxWidth: 200,
                        in: view,
                        from: storyTextBackgroundView.frame,
                        duration: 2.5)
            view.bringSubviewToFront(popTip)
            break
        case .enter:
            view.bringSubviewToFront(storyTextBackgroundView)
            view.bringSubviewToFront(storyTextView)
            view.bringSubviewToFront(buttonStackView)
            popTip = initPopTip()
            popTip.offset = 10
            popTip.show(text: "tooltip.storyshare.instruction.enter".localized,
                        direction: .down,
                        maxWidth: 200,
                        in: view,
                        from: buttonStackView.frame)
            view.bringSubviewToFront(popTip)
            break
        case .period:
            view.bringSubviewToFront(storyTextBackgroundView)
            view.bringSubviewToFront(storyTextView)
            view.bringSubviewToFront(buttonStackView)
            popTip = initPopTip()
            popTip.arrowOffset = 70
            popTip.show(text: "tooltip.storyshare.instruction.period".localized,
                        direction: .down,
                        maxWidth: 200,
                        in: view,
                        from: buttonStackView.frame)
            view.bringSubviewToFront(popTip)
            break
        case .done:
            popTip = initPopTip(dismissable: true)
            popTip.show(text: "tooltip.common.instruction.play".localized,
                        direction: .up,
                        maxWidth: 150,
                        in: view,
                        from: nextButton.frame,
                        duration: 2.5)
            view.bringSubviewToFront(popTip)
            break
        }
    }
    
    private func nextInstruction() {
        
        instructionBGView.fadeTransition(0.1)
        instructionBGView.layer.opacity = 0
        popTip.hide()
        instruction = instruction.next()
        
        switch instruction {
        case .invited:
            break
        case .dictionary:
            loadTutorialGameData2()
            typeHereInstructionLabel.isHidden = true
        case .enter:
            loadTutorialGameData3()
            enterButton.isUserInteractionEnabled = false
            invisibleTextField.text = "over the lazy"
            invisibleTextField.setNeedsDisplay()
            viewModel.currentInput.accept("over the lazy")
            dictionaryView.isHidden = true
            dictionaryView.isUserInteractionEnabled = false
            break
        case .period:
            loadTutorialGameData4()
            periodButton.isUserInteractionEnabled = false
            invisibleTextField.text = "hotdog sandwich"
            invisibleTextField.setNeedsDisplay()
            viewModel.currentInput.accept("hotdog sandwich")
            break
        case .done:
            buttonStackView.isHidden = true
            storyTextBackgroundView.isHidden = true
            nextButton.setTitle("common.play".localized, for: .normal)
        }
        
        showInstructionView()
    }
    
    private func initPopTip(dismissable: Bool = false, darkmode: Bool = false) -> PopTip {
        let popTip = PopTip()
        popTip.bubbleColor = darkmode ? .chestnut : .white
        popTip.textColor = darkmode ? .white : .jet
        popTip.padding = 10
        popTip.edgeMargin = 10
        popTip.shouldDismissOnTap = dismissable
        popTip.shouldDismissOnTapOutside = dismissable
        popTip.shouldDismissOnSwipeOutside = dismissable
        popTip.font = .futuraBook(12)
        return popTip
    }
    
    private func addInstructionGradientLayer() {
        let colorTop =  UIColor.darkGray.cgColor
        let colorBottom = UIColor.gray.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = instructionBGView.bounds
        gradientLayer.opacity = 0.75
        instructionBGView.layer.insertSublayer(gradientLayer, at:0)
        instructionBGView.bringSubviewToFront(nextButton)
    }
    
    private func loadTutorialGameData2() {
        
        if let path = Bundle.main.path(forResource: "storyshare-turotial-game-detail-2", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)
                print("jsonData:\(jsonObj)")
                var response = GetStoryShareResponse(jsonObj)
                response.storyShare?.invitee?.id = MemCached.shared.userInfo?.id
                response.storyShare?.invitee?.firstName = MemCached.shared.userInfo?.firstName
                response.storyShare?.invitee?.lastName = MemCached.shared.userInfo?.lastName
                response.storyShare?.invitee?.avatar?.image = MemCached.shared.userInfo?.profileImages[0].image
                response.storyShare?.invitee?.avatar?.user = MemCached.shared.userInfo?.id
                viewModel.detail.accept(response.storyShare)
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
    }
    
    private func loadTutorialGameData3() {
        
        if let path = Bundle.main.path(forResource: "storyshare-turotial-game-detail-3", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)
                print("jsonData:\(jsonObj)")
                var response = GetStoryShareResponse(jsonObj)
                response.storyShare?.invitee?.id = MemCached.shared.userInfo?.id
                response.storyShare?.invitee?.firstName = MemCached.shared.userInfo?.firstName
                response.storyShare?.invitee?.lastName = MemCached.shared.userInfo?.lastName
                response.storyShare?.invitee?.avatar?.image = MemCached.shared.userInfo?.profileImages[0].image
                response.storyShare?.invitee?.avatar?.user = MemCached.shared.userInfo?.id
                response.storyShare?.currentPlayerTurn = MemCached.shared.userInfo?.id
                viewModel.detail.accept(response.storyShare)
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
    }
    
    private func loadTutorialGameData4() {
        
        if let path = Bundle.main.path(forResource: "storyshare-turotial-game-detail-4", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)
                print("jsonData:\(jsonObj)")
                var response = GetStoryShareResponse(jsonObj)
                response.storyShare?.invitee?.id = MemCached.shared.userInfo?.id
                response.storyShare?.invitee?.firstName = MemCached.shared.userInfo?.firstName
                response.storyShare?.invitee?.lastName = MemCached.shared.userInfo?.lastName
                response.storyShare?.invitee?.avatar?.image = MemCached.shared.userInfo?.profileImages[0].image
                response.storyShare?.invitee?.avatar?.user = MemCached.shared.userInfo?.id
                response.storyShare?.currentPlayerTurn = MemCached.shared.userInfo?.id
                viewModel.detail.accept(response.storyShare)
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
    }
}
