//
//  EmojiGoTutorialGameViewController.swift
//  Elated
//
//  Created by Rey Felipe on 10/13/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import AMPopTip
import IQKeyboardManagerSwift
import SwiftyJSON

class EmojiGoTutorialGameViewController: BaseViewController {
    
    enum InstructionTag: Int {
        case timer
        case selectQuestion
        case questionSent
        case turn
        case skipTurn
        case done
        
        func next() -> InstructionTag {
            switch self {
            case .timer:
                return .selectQuestion
            case .selectQuestion:
                return .questionSent
            case .questionSent:
                return .turn
            case .turn:
                return .skipTurn
            case .skipTurn, .done:
                return .done
            }
        }
    }
    private var instruction: InstructionTag = InstructionTag.timer

    let viewModel = EmojiGoGameViewModel(tutorialMode: true)
    
    internal var chatTableView = EmojiGoChatTableView()
    
    internal var questionView: EmojiQuestionView?
    
    internal let bgImage: UIImageView = UIImageView(image: #imageLiteral(resourceName: "bg-pulse"))
    
    private let titleImageView = UIImageView(image: #imageLiteral(resourceName: "icon_emoji_text"))
    
    internal let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-back").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    internal let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-gear-white"), for: .normal)
        return button
    }()
    
    internal let goButton: UIButton = {
        let button = UIButton()
        button.setTitle("common.go!".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.cornerRadius = 25
        button.titleLabel?.font = .comfortaaBold(14)
        button.layer.applySketchShadow(color: .black,
                                       alpha: 0.15,
                                       x: 0,
                                       y: 3,
                                       blur: 18,
                                       spread: 0)
        button.clipsToBounds = true
        button.isUserInteractionEnabled = false
        return button
    }()
    
    internal let passButton: UIButton = {
        let button = UIButton()
        button.setTitle("emojiGo.settings.pass".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.cornerRadius = 25
        button.titleLabel?.font = .comfortaaBold(14)
        button.layer.applySketchShadow(color: .black,
                                       alpha: 0.15,
                                       x: 0,
                                       y: 3,
                                       blur: 18,
                                       spread: 0)
        button.clipsToBounds = true
        button.isUserInteractionEnabled = false
        return button
    }()
    
    internal lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [goButton, passButton])
        stackView.axis = .horizontal
        stackView.spacing = 12
        return stackView
    }()
    
    internal let circleOuter: UIView = {
        let view = UIView()
        view.backgroundColor = .goGradient_FFAE2E
        view.layer.cornerRadius = 40
        return view
    }()
    
    internal let circleInner: UIView = {
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
    
    internal let turnLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .futuraMedium(20)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    internal let keyWindow = UIApplication.shared.connectedScenes
                                .filter({$0.activationState == .foregroundActive})
                                .map({$0 as? UIWindowScene})
                                .compactMap({$0})
                                .first?.windows
                                .filter({$0.isKeyWindow}).first

    internal lazy var timesUpView = EmojiGoTimesUpPopup(frame: keyWindow!.frame)

    internal lazy var skipView = EmojiGoSkipPopup(frame: keyWindow!.frame)
    
    internal let textInputView = EmojiGoKeyboardAccessoryView()
    
    internal lazy var emojiCountBubble: AlertBubble = {
        let alert = AlertBubble(.bottomLeft,
                                text: "emojiGo.emoji.limit".localized,
                                color: .white,
                                textColor: .elatedPrimaryPurple)
        alert.label.font = .comfortaaBold(12)
        alert.label.paddingTop = 20;
        alert.label.paddingBottom = 20;
        alert.label.paddingLeft = 20;
        alert.label.paddingRight = 20;
        alert.isHidden = true
        return alert
    }()
    
    private let instructionBGView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.opacity = 0
        return view
    }()
    internal let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("common.next".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.cornerRadius = 25
        button.titleLabel?.font = .comfortaaBold(14)
        button.layer.applySketchShadow(color: .black,
                                       alpha: 0.15,
                                       x: 0,
                                       y: 3,
                                       blur: 18,
                                       spread: 0)
        button.clipsToBounds = true
        return button
    }()
    private var popTip = PopTip()
    var completionHandler: (() -> Void)?
    
    init(_ detail: EmojiGoGameDetail) {
        super.init(nibName: nil, bundle: nil)
        viewModel.detail.accept(detail)
        loadTutorialGameQuestions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //apply gradient after layout
        goButton.gradientBackground(from: .maximumYellowRed,
                                    to: .brightYellowCrayola,
                                    direction: .bottomToTop)
        nextButton.gradientBackground(from: .maximumYellowRed,
                                      to: .brightYellowCrayola,
                                      direction: .bottomToTop)
        passButton.gradientBackground(from: .lavanderFloral,
                                      to: .darkOrchid,
                                      direction: .topToBottom)
        
        addInstructionGradientLayer()
        showInstructionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.addSubview(bgImage)
        bgImage.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(-2)
            make.right.equalToSuperview().offset(2)
        }
        
        view.addSubview(textInputView)
        textInputView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(80)
        }
        
        view.addSubview(titleImageView)
        titleImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(17)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(19)
            make.centerY.equalTo(titleImageView)
            make.width.height.equalTo(25)
        }
        
        view.addSubview(settingsButton)
        settingsButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleImageView)
            make.right.equalTo(-19)
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
        
        view.addSubview(turnLabel)
        turnLabel.snp.makeConstraints { make in
            make.center.equalTo(circleOuter)
        }
        
        view.addSubview(chatTableView)
        chatTableView.snp.makeConstraints { make in
            make.top.equalTo(circleOuter.snp.bottom).offset(17)
            make.left.right.equalToSuperview().inset(30)
        }
        
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(chatTableView.snp.bottom).offset(16)
            make.centerX.equalTo(chatTableView)
            make.bottom.equalTo(textInputView.snp.top).offset(-36)
        }
        
        goButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(148)
        }
        
        passButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(148)
        }
        
        view.addSubview(emojiCountBubble)
        emojiCountBubble.snp.makeConstraints { make in
            make.bottom.equalTo(textInputView.snp.top)
            make.left.equalToSuperview().inset(22)
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
        super.bind()
        
        nextButton.rx.tap.bind { [weak self] in
            if self?.instruction != .done {
                if self?.instruction == .selectQuestion {
                    guard let question = self?.questionView?.selectedQuestion.value
                    else { return }
                }
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
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.textInputView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().inset(keyboardHeight)
                }
                
                self.buttonStackView.isHidden = true
                self.buttonStackView.snp.updateConstraints { make in
                    make.bottom.equalTo(self.textInputView.snp.top).inset(62)
                }
    
                self.backButton.isHidden = true
                self.settingsButton.isHidden = true
                self.titleImageView.isHidden = true
                
                self.titleImageView.snp.updateConstraints { make in
                    make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                }
                
                self.chatTableView.snp.updateConstraints { make in
                    make.top.equalTo(self.circleOuter.snp.bottom).offset(8)
                }
                
                self.circleOuter.snp.updateConstraints { make in
                    make.top.equalTo(self.titleImageView.snp.bottom).inset(25)
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                self.chatTableView.scrollToBottom()
            })
            
        }
    }
    
    @objc internal func keyboardWillHide(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.textInputView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(80)
            }
            
            self.buttonStackView.isHidden = !MemCached.shared.isSelf(id: self.viewModel.detail.value?.currentPlayerTurn)
            self.buttonStackView.snp.updateConstraints { make in
                make.bottom.equalTo(self.textInputView.snp.top).offset(-36)
            }
            
            self.backButton.isHidden = false
            self.settingsButton.isHidden = false
            self.titleImageView.isHidden = false
            
            self.titleImageView.snp.updateConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(17)
            }
            
            self.chatTableView.snp.updateConstraints { make in
                make.top.equalTo(self.circleOuter.snp.bottom).offset(17)
            }
            
            self.circleOuter.snp.updateConstraints { make in
                make.top.equalTo(self.titleImageView.snp.bottom).offset(23)
            }
        }
    }
    
}

//MARK: - Tooltip
extension EmojiGoTutorialGameViewController {
    
    private func showInstructionView() {
        instructionBGView.fadeTransition(0.1)
        view.bringSubviewToFront(instructionBGView)
        instructionBGView.layer.opacity = 1
        
        switch instruction {
        case .timer:
            view.bringSubviewToFront(circleOuter)
            popTip = initPopTip()
            popTip.show(text: "tooltip.emojigo.instruction.timer".localized,
                        direction: .down,
                        maxWidth: 150,
                        in: view,
                        from: circleOuter.frame)
            view.bringSubviewToFront(popTip)
        case .selectQuestion:
            view.bringSubviewToFront(questionView!)
            popTip = initPopTip(dimissable: true)
            popTip.show(text: "tooltip.emojigo.instruction.select.question".localized,
                        direction: .up,
                        maxWidth: 250,
                        in: view,
                        from: questionView!.frame,
                        duration: 2.5)
            view.bringSubviewToFront(popTip)
        case .questionSent:
            chatTableView.backgroundColor = .gray
            view.bringSubviewToFront(chatTableView)
            let cells = chatTableView.visibleCells
            for i in cells {
                let cell: UITableViewCell = i as UITableViewCell
                view.bringSubviewToFront(cell)
            }
            chatTableView.clipsToBounds = false
            popTip = initPopTip(dimissable: true)
            popTip.show(text: "tooltip.emojigo.instruction.sent.question".localized,
                        direction: .up,
                        maxWidth: 250,
                        in: chatTableView,
                        from: cells.first?.frame ?? chatTableView.frame,
                        duration: 3.0)
            view.bringSubviewToFront(popTip)
        case .turn:
            chatTableView.backgroundColor = .gray
            view.bringSubviewToFront(chatTableView)
            let cells = chatTableView.visibleCells
            for i in cells {
                let cell: UITableViewCell = i as UITableViewCell
                view.bringSubviewToFront(cell)
            }
            view.bringSubviewToFront(buttonStackView)
            popTip = initPopTip()
            popTip.offset = 75
            popTip.arrowOffset = 75
            popTip.show(text: "tooltip.emojigo.instruction.your.turn".localized,
                        direction: .up,
                        maxWidth: 250,
                        in: view,
                        from: buttonStackView.frame)
            view.bringSubviewToFront(popTip)
        case .skipTurn:
            chatTableView.backgroundColor = .gray
            view.bringSubviewToFront(chatTableView)
            let cells = chatTableView.visibleCells
            for i in cells {
                let cell: UITableViewCell = i as UITableViewCell
                view.bringSubviewToFront(cell)
            }
            view.bringSubviewToFront(buttonStackView)
            popTip = initPopTip()
            //popTip.offset = 75
            popTip.arrowOffset = -75
            popTip.show(text: "tooltip.emojigo.instruction.skip.turn".localized,
                        direction: .up,
                        maxWidth: 250,
                        in: view,
                        from: buttonStackView.frame)
            view.bringSubviewToFront(popTip)
            break
        case .done:
            popTip = initPopTip(dimissable: true)
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
//        detachKeyboardOverlay()
        instruction = instruction.next()
        
        switch instruction {
        case .timer, .selectQuestion:
            break
        case .questionSent:
            loadTutorialGameData2()
        case .turn:
            chatTableView.backgroundColor = .appLightSkyBlue
            //load the next game data
            loadTutorialGameData3()
            goButton.setTitle("common.answer".localized, for: .normal)
            buttonStackView.snp.updateConstraints{ make in
                make.bottom.equalTo(textInputView.snp.top).offset(-106)
            }
        case .skipTurn:
            chatTableView.backgroundColor = .appLightSkyBlue
        case .done:
            chatTableView.backgroundColor = .appLightSkyBlue
            nextButton.setTitle("common.play".localized, for: .normal)
            buttonStackView.snp.updateConstraints{ make in
                make.bottom.equalTo(textInputView.snp.top).offset(-36)
            }
        }
        
        showInstructionView()
    }
    
//    private func attachKeyboardOverlay() {
//        // Calculate and replace the frame according to your keyboard frame
//        keyboardOverlayView = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height-keyboardHeight, width: self.view.frame.size.width, height: keyboardHeight))
//        keyboardOverlayView.backgroundColor = .clear
//        keyboardOverlayView.layer.zPosition = CGFloat(MAXFLOAT)
//
//        let backGroundView = UIView()
//        backGroundView.backgroundColor = .elatedSecondaryPurple
//        backGroundView.layer.opacity = 0.5
//        keyboardOverlayView.addSubview(backGroundView)
//        backGroundView.snp.makeConstraints { make in
//            make.top.bottom.width.height.equalToSuperview()
//        }
//
//        let nextButton = UIButton.createCommonBottomButton("common.next")
//        keyboardOverlayView.addSubview(nextButton)
//        nextButton.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.height.equalTo(50)
//            make.left.right.equalToSuperview().inset(33)
//            make.bottom.equalToSuperview().offset(-25)
//        }
//
//        nextButton.rx.tap.bind { [weak self] in
//            self?.nextInstruction()
//        }.disposed(by: disposeBag)
//
//        let windowCount = UIApplication.shared.windows.count
//        UIApplication.shared.windows[windowCount-1].addSubview(keyboardOverlayView)
//    }
    
//    private func detachKeyboardOverlay() {
//        keyboardOverlayView.removeFromSuperview()
//    }
    
    private func initPopTip(dimissable: Bool = false, darkmode: Bool = false) -> PopTip {
        let popTip = PopTip()
        popTip.bubbleColor = darkmode ? .elatedPrimaryPurple : .alabasterBlue
        popTip.textColor = darkmode ? .alabasterBlue : .elatedPrimaryPurple
        popTip.padding = 10
        popTip.edgeMargin = 10
        popTip.shouldDismissOnTap = dimissable
        popTip.shouldDismissOnTapOutside = dimissable
        popTip.shouldDismissOnSwipeOutside = dimissable
        popTip.font = .futuraLight(12)
        return popTip
    }
    
    private func addInstructionGradientLayer() {
        let colorTop =  UIColor.black.cgColor
        let colorBottom = UIColor.gray.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = instructionBGView.bounds
        gradientLayer.opacity = 0.75
        instructionBGView.layer.insertSublayer(gradientLayer, at:0)
        instructionBGView.bringSubviewToFront(nextButton)
    }
    
    
    private func loadTutorialGameQuestions() {
        
        if let path = Bundle.main.path(forResource: "emojigo-turotial-game-questions", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)
                let response = GetEmojiGoQuestionsResponse(jsonObj)
                #if DEBUG
                print("Questions: \(JSON(jsonObj))")
                #endif
                viewModel.questions.accept(response.questions)
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        
    }
    
    private func loadTutorialGameData2() {
        
        if let path = Bundle.main.path(forResource: "emojigo-turotial-game-detail-2", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)
                print("jsonData:\(jsonObj)")
                var response = EmojiGoGameDetail(jsonObj)
                response.invitee?.id = MemCached.shared.userInfo?.id
                response.invitee?.firstName = MemCached.shared.userInfo?.firstName
                response.invitee?.lastName = MemCached.shared.userInfo?.lastName
                response.invitee?.avatar?.image = MemCached.shared.userInfo?.profileImages[0].image
                response.invitee?.avatar?.user = MemCached.shared.userInfo?.id
                response.emojigo[0].question?.user = MemCached.shared.userInfo?.id
                viewModel.detail.accept(response)
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        
    }
    
    private func loadTutorialGameData3() {
        
        if let path = Bundle.main.path(forResource: "emojigo-turotial-game-detail-3", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)
                print("jsonData:\(jsonObj)")
                var response = EmojiGoGameDetail(jsonObj)
                response.invitee?.id = MemCached.shared.userInfo?.id
                response.invitee?.firstName = MemCached.shared.userInfo?.firstName
                response.invitee?.lastName = MemCached.shared.userInfo?.lastName
                response.invitee?.avatar?.image = MemCached.shared.userInfo?.profileImages[0].image
                response.invitee?.avatar?.user = MemCached.shared.userInfo?.id
                response.currentPlayerTurn = MemCached.shared.userInfo?.id
                response.emojigo[0].question?.user = MemCached.shared.userInfo?.id
                viewModel.detail.accept(response)
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        
    }
}
