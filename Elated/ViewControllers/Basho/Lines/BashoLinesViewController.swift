//
//  BashoInvitesViewController.swift
//  Elated
//
//  Created by Marlon on 4/14/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift

class BashoLinesViewController: BaseViewController {

    private let viewModel = BashoLinesViewModel()
    
    private var reviewer: ReviewerSparkFlirtHistory
    
    private let lockImageView = UIImageView(image: #imageLiteral(resourceName: "asset-75px-chat-locked-0"))
    
    private let keyWindow = UIApplication.shared.connectedScenes
                                .filter({$0.activationState == .foregroundActive})
                                .map({$0 as? UIWindowScene})
                                .compactMap({$0})
                                .first?.windows
                                .filter({$0.isKeyWindow}).first
    
    private lazy var settingsView = BashoMenuSettingPopup(frame: keyWindow!.frame)

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .futuraMedium(22)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .futuraMedium(14)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BashoLinesTableViewCell.self,
                      forCellReuseIdentifier: BashoLinesTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-gear-white"), for: .normal)
        return button
    }()

    private lazy var continueButton = UIButton.createCommonBottomButton("common.continue")
    private lazy var sendNudgeButton = UIButton.createCommonBottomButton("common.sendNudge")

    private var timer: Timer?
    
    internal lazy var alertBubble: AlertBubble = {
        let alert = AlertBubble(.bottomCenter,
                                text: "basho.complete.sparkFlirt.sendNudge.tip".localized,
                                color: .white,
                                textColor: .elatedPrimaryPurple)
        alert.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideTip)))
        return alert
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    init(_ detail: BashoGameDetail) {
        
        //initialize reviewer
        let otherUser = MemCached.shared.isSelf(id: detail.invitee?.id) ? detail.invitee : detail.inviter
        reviewer = ReviewerSparkFlirtHistory(otherUserID: otherUser?.id ?? 0)
        reviewer.gameDetail.accept(detail)
        
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.tipShowed.accept(MemCached.shared.userInfo?.id == detail.currentPlayerTurn)
        alertBubble.label.text = "basho.complete.sparkFlirt.sendNudge.tip".localizedFormat("\(otherUser?.firstName ?? "")",
                                                                                           "\(otherUser?.firstName ?? "")")
        viewModel.detail.accept(detail)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Basho"
        self.navigationController?.hideNavBar()
        timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(hideTip), userInfo: nil, repeats: false)
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        let bgImageView = UIImageView(image: #imageLiteral(resourceName: "graphic-basho-bg"))
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(-5)
            make.right.equalTo(5)
        }
        
        view.addSubview(settingsButton)
        settingsButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(8)
            make.right.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }
        
        view.addSubview(lockImageView)
        lockImageView.snp.makeConstraints { make in
            make.top.equalTo(settingsButton.snp.bottom).offset(22)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(75)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(lockImageView.snp.bottom).offset(25)
            make.left.right.equalToSuperview().inset(22)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(22)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }
        
        //other player turn
        if MemCached.shared.userInfo?.id != viewModel.detail.value?.currentPlayerTurn {
            view.addSubview(sendNudgeButton)
            sendNudgeButton.snp.makeConstraints { make in
                make.top.equalTo(tableView.snp.bottom).offset(20)
                make.left.right.equalToSuperview().inset(32)
                make.height.equalTo(50)
            }
            
            view.addSubview(alertBubble)
            alertBubble.snp.remakeConstraints { make in
                make.bottom.equalTo(sendNudgeButton.snp.top).offset(-2)
                make.left.right.equalTo(sendNudgeButton)
            }
            
            view.addSubview(continueButton)
            continueButton.snp.remakeConstraints { make in
                make.top.equalTo(sendNudgeButton.snp.bottom).offset(20)
                make.left.right.equalTo(sendNudgeButton)
                make.bottom.equalToSuperview().inset(57)
                make.height.equalTo(50)
            }
            continueButton.backgroundColor = .white
            continueButton.setTitleColor(.elatedPrimaryPurple, for: .normal)
        } else {
            //current player turn
            view.addSubview(continueButton)
            continueButton.snp.makeConstraints { make in
                make.top.equalTo(tableView.snp.bottom).offset(20)
                make.left.right.equalToSuperview().inset(32)
                make.bottom.equalToSuperview().inset(57)
                make.height.equalTo(50)
            }
        }
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        viewModel.detail.subscribe(onNext: { [weak self] detail in
            guard let self = self,
                  let detail = detail else { return }
            let count = detail.basho.count
            self.tableView.reloadData()
            
            let otherUser: Invitee? = MemCached.shared.isSelf(id: detail.invitee?.id) ? detail.invitee : detail.inviter

            //set titles
            if count == 0 {
                if MemCached.shared.userInfo?.id == detail.currentPlayerTurn {
                    //my turn
                    self.titleLabel.text = "basho.line.myTurn.title".localized
                    self.subLabel.text = "basho.line.myTurn.subTitle".localizedFormat("1st")
                } else {
                    self.titleLabel.text = "basho.line.other.title".localizedFormat("\(otherUser?.firstName ?? "")")
                    self.subLabel.text = ""
                }
            } else if count == 1 {
                if MemCached.shared.userInfo?.id == detail.currentPlayerTurn {
                    //my turn
                    self.titleLabel.text = "basho.line.myTurn.title".localized
                    self.subLabel.text = "basho.line.myTurn.subTitle".localizedFormat("2nd")
                } else {
                    if detail.basho[0].line.isEmpty {
                        //1st line was skipped
                        self.titleLabel.text = ""
                        self.subLabel.text = "basho.line.user.turn.skipped".localizedFormat("1st")
                    } else {
                        self.titleLabel.text = ""
                        self.subLabel.text = "basho.line.user.turn.done.1".localizedFormat("\(detail.basho[0].time)")
                    }
                }
            } else if count == 2 {
                if MemCached.shared.userInfo?.id == detail.currentPlayerTurn {
                    //my turn
                    self.titleLabel.text = "basho.line.myTurn.title".localized
                    self.subLabel.text = "basho.line.myTurn.subTitle".localizedFormat("3rd")
                } else {
                    if detail.basho[1].line.isEmpty {
                        //2nd line was skipped
                        self.titleLabel.text = ""
                        self.subLabel.text = "basho.line.user.turn.skipped".localizedFormat("2nd")
                    } else {
                        self.titleLabel.text = ""
                        self.subLabel.text = "basho.line.user.turn.done.1".localizedFormat("\(detail.basho[1].time)")
                    }
                }
            } else if count == 3 {
                //look for skipped line
                if detail.basho[0].line.isEmpty {
                    if MemCached.shared.userInfo?.id == detail.currentPlayerTurn {
                        //my turn
                        self.titleLabel.text = "basho.line.myTurn.title".localized
                        self.subLabel.text = "basho.line.myTurn.subTitle".localizedFormat("1st")
                    } else {
                        //3rd line was skipped
                        self.titleLabel.text = ""
                        self.subLabel.text = "basho.line.user.turn.skipped".localizedFormat("3rd")
                    }
                } else if detail.basho[1].line.isEmpty {
                    if MemCached.shared.userInfo?.id == detail.currentPlayerTurn {
                        //my turn
                        self.titleLabel.text = "basho.line.myTurn.title".localized
                        self.subLabel.text = "basho.line.myTurn.subTitle".localizedFormat("2nd")
                    } else {
                        //1st line was skipped
                        self.titleLabel.text = ""
                        self.subLabel.text = "basho.line.user.turn.skipped".localizedFormat("1st")
                    }
                } else if detail.basho[2].line.isEmpty {
                    if MemCached.shared.userInfo?.id == detail.currentPlayerTurn {
                        //my turn
                        self.titleLabel.text = "basho.line.myTurn.title".localized
                        self.subLabel.text = "basho.line.myTurn.subTitle".localizedFormat("3rd")
                    } else {
                        //1st line was skipped
                        self.titleLabel.text = ""
                        self.subLabel.text = "basho.line.user.turn.skipped".localizedFormat("2nd")
                    }
                }
            }
        }).disposed(by: disposeBag)
        
        viewModel.tipShowed.subscribe(onNext: { [weak self] showed in
            self?.alertBubble.isHidden = showed
        }).disposed(by: disposeBag)
        
        viewModel.successNudge.subscribe(onNext: { [weak self] _ in
            self?.presentAlert(title: "common.sendNudge".localized,
                               message: "common.sendNudge.message".localized) {
                if let nav = self?.navigationController {
                    let controller = nav.viewControllers[nav.viewControllers.count - 3]
                    self?.navigationController?.setNavigationBarHidden(false, animated: true)
                    self?.navigationController?.popToViewController(controller, animated: true)
                }
            }
        }).disposed(by: disposeBag)
        
        viewModel.successEndBasho.subscribe(onNext: { [weak self] _ in
            if let nav = self?.navigationController {
                let controller = nav.viewControllers[nav.viewControllers.count - 3]
                self?.navigationController?.setNavigationBarHidden(false, animated: true)
                self?.navigationController?.popToViewController(controller, animated: true)
            }
        }).disposed(by: disposeBag)
        
        viewModel.successBlockUser.subscribe(onNext: { [weak self] _ in
            if let nav = self?.navigationController {
                let controller = nav.viewControllers[nav.viewControllers.count - 3]
                self?.navigationController?.setNavigationBarHidden(false, animated: true)
                self?.navigationController?.popToViewController(controller, animated: true)
            }
        }).disposed(by: disposeBag)
        
        settingsButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.presentViewPopup(popup: self.settingsView)
        }.disposed(by: disposeBag)
        
        settingsView.didBack.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.dismissViewPopup(popup: self.settingsView) { }
        }).disposed(by: disposeBag)
        
        settingsView.didViewTutorial.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.dismissViewPopup(popup: self.settingsView) {
                self.show(BashoTutorialIntroViewController(), sender: nil)
            }
        }).disposed(by: disposeBag)
        
        settingsView.didBlockUser.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.dismissViewPopup(popup: self.settingsView) {
                self.presentAlert(title: "basho.settings.menu.button.blockUser".localized,
                                   message: "basho.settings.menu.button.blockUser.message".localized) {
                    self.viewModel.blockUser()
                }
            }
        }).disposed(by: disposeBag)
        
        settingsView.didChangeGame.subscribe(onNext: {
            let vc = MenuTabBarViewController([.navigateSparkFlirtInvite])
            vc.selectedIndex = MenuTabBarViewController.MenuIndex.sparkFlirt.rawValue
            let landingNav = UINavigationController(rootViewController: vc)
            Util.setRootViewController(landingNav)
        }).disposed(by: disposeBag)
        
        settingsView.didEndGame.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.dismissViewPopup(popup: self.settingsView) {
                self.presentAlert(title: "basho.settings.menu.button.endGame".localized,
                                   message: "basho.settings.menu.button.endGame.message".localized) {
                    self.viewModel.endGame()
                }
            }
        }).disposed(by: disposeBag)
        
        continueButton.rx.tap.bind { [weak self] in
            guard let self = self,
                  let detail = self.viewModel.detail.value
            else { return }
            if MemCached.shared.userInfo?.id == detail.currentPlayerTurn {
                //my turn
                self.show(BashoGameViewController(detail), sender: nil)
            } else {
                //other turn
                if let nav = self.navigationController {
                    let controller = nav.viewControllers[nav.viewControllers.count - 3]
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                    self.navigationController?.popToViewController(controller, animated: true)
                }
            }
        }.disposed(by: disposeBag)
        
        sendNudgeButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.viewModel.sendNudge()
        }.disposed(by: disposeBag)
        
        //MARK: SparkFlirt Reviewer
        reviewer.lockImage.bind(to: lockImageView.rx.image).disposed(by: disposeBag)

    }
    
    @objc private func hideTip() {
        viewModel.tipShowed.accept(true)
    }
    
}

extension BashoLinesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BashoLinesTableViewCell.identifier)
            as? BashoLinesTableViewCell ?? BashoLinesTableViewCell()
        let basho = viewModel.detail.value?.basho ?? []
        let count = basho.count
        
        let invitee = viewModel.detail.value?.invitee
        let inviter = viewModel.detail.value?.inviter
        
        let inviteeImage = invitee?.avatar?.image ?? ""
        let inviterImage = inviter?.avatar?.image ?? ""

        switch HaikuLine(rawValue: (indexPath.row + 1))! {
        case .top:
            let bashoLine = count > 0 ? basho[0].line : ""
            cell.set(bashoLine, line: .top, profileImage: URL(string: inviteeImage))
            break
        case .middle:
            let bashoLine = count > 1 ? basho[1].line  : ""
            cell.set(bashoLine, line: .middle, profileImage: URL(string: inviterImage))
            break
        case .bottom:
            let bashoLine = count > 2 ? basho[2].line  : ""
            cell.set(bashoLine, line: .bottom, profileImage: URL(string: inviteeImage))
            break
        }
        return cell
    }
    
}
