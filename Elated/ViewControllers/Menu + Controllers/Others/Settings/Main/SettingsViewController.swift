//
//  SettingsViewController.swift
//  Elated
//
//  Created by Marlon on 2021/3/9.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import SideMenu

class SettingsViewController: BaseViewController {

    //MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 36.0
            
            tableView.sectionHeaderHeight = UITableView.automaticDimension
            tableView.estimatedSectionHeaderHeight = 20.0
            
            tableView.reloadData()
        }
    }
    
    internal lazy var menu = self.createMenu(SideMenuViewController.shared)
    internal let menuButton = UIBarButtonItem.createMenuButton()
    
    let viewModel = SettingsViewModel()
    
    //MARK: - View Life Cycle
    
    static func instantiate() -> SettingsViewController {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else {
            fatalError("Cannot instantiate SettingsViewController")
        }
        
      return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        viewModel.getProfile()
    }
    
    override func bind() {
        super.bind()
        
        bindView()
        bindEvents()
    }
    
    //MARK: - Custom
    
    private func setupNavBar() {
        self.title = "menu.item.settings".localized
        menuButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = menuButton
        
        self.setupNavigationBar(.white,
                                font: .futuraMedium(20),
                                tintColor: .white,
                                backgroundImage: #imageLiteral(resourceName: "background-header"))
        
    }
    
    private func setupTableView() {
        
    }
}

//MARK: - UITableView Data Source
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 6
        default:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTitleWithSubtitleTableViewCell.identifier) as! SettingsTitleWithSubtitleTableViewCell
            cell.setupCell(title: viewModel.rowTitles[indexPath.row],
                           subtitle: viewModel.rowSubtitles[indexPath.row])
            return cell
            
        case 1:
            let rowIndex = indexPath.row + tableView.numberOfRows(inSection: 0)
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTitleWithSubtitleTableViewCell.identifier) as! SettingsTitleWithSubtitleTableViewCell
                cell.setupCell(title: viewModel.rowTitles[rowIndex],
                               subtitle: viewModel.notifFrequency.value?.getName() ?? "")
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTitleWithSwitchTableViewCell.identifier) as! SettingsTitleWithSwitchTableViewCell
            
            var isOn = false
            switch self.viewModel.rowTitles[rowIndex] {
                case "settings.cell.title.new.match".localized:
                    isOn = self.viewModel.notifMatch.value
                    break
                case "settings.cell.title.new.message".localized:
                    isOn = self.viewModel.notifEmail.value
                    break
                case "settings.cell.title.sparkflirt".localized:
                    isOn = self.viewModel.notifSparkFlirtInvite.value
                    break
                case "settings.cell.title.favorited".localized:
                    isOn = self.viewModel.notifFavorite.value
                    break
                case "settings.cell.title.nudge".localized:
                    isOn = self.viewModel.notifNudge.value
                    break
                default:
                    break
            }
            
            cell.setupCell(title: viewModel.rowTitles[rowIndex],
                           isOn: isOn)
            
            cell.didChange = { [unowned self] arg in
                switch self.viewModel.rowTitles[rowIndex] {
                    case "settings.cell.title.new.match".localized:
                        self.viewModel.notifMatch.accept(arg)
                        return
                    case "settings.cell.title.new.message".localized:
                        self.viewModel.notifEmail.accept(arg)
                        return
                    case "settings.cell.title.sparkflirt".localized:
                        self.viewModel.notifSparkFlirtInvite.accept(arg)
                        return
                    case "settings.cell.title.favorited".localized:
                        self.viewModel.notifFavorite.accept(arg)
                        return
                    case "settings.cell.title.nudge".localized:
                        self.viewModel.notifNudge.accept(arg)
                        return
                    default:
                        return
                }
            }
            
            return cell
            
        default:
            let rowIndex = indexPath.row + tableView.numberOfRows(inSection: 0) + tableView.numberOfRows(inSection: 1)
            
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTitleWithSubtitleTableViewCell.identifier) as! SettingsTitleWithSubtitleTableViewCell
            let shouldApplyRedTint = indexPath.row == 0 ? false : true
            
            cell.setupCell(title: viewModel.rowTitles[rowIndex],
                           subtitle: "",
                           shouldApplyRedTint: shouldApplyRedTint)
            return cell
        }
    }
}

//MARK: - UITableView Delegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            handleRedirectionScreensForEditSettings(row: indexPath.row)
        case 1:
            handleRedirectionScreensForNotificationSettings(row: indexPath.row)
        default:
            handleRedirectionScreensForAccountSettings(row: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 11 : 7
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section > 0 else { return UIView() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsHeaderTableViewCell.identifier) as! SettingsHeaderTableViewCell
        cell.setupCell(title: viewModel.sectionTitles[section - 1])
        
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    private func handleRedirectionScreensForEditSettings(row: Int) {
        switch row {
        case 0:
            let viewController = EditProfileGenderViewController(.settings,
                                                                 gender: viewModel.gender.value,
                                                                 isGenderPreference: true)
            self.show(viewController, sender: nil)
        case 1:
            let viewController = SettingsAgeViewController(.settings,
                                                           minAge: viewModel.minAge.value,
                                                           maxAge: viewModel.maxAge.value)
            self.show(viewController, sender: nil)
        case 2:
            let viewController = EditProfileRangeViewController(.settings,
                                                                distanceType: viewModel.distanceMetric.value,
                                                                range: viewModel.distance.value)
            self.show(viewController, sender: nil)
        default:
            let viewController = SettingsLocationViewController(type: .settings,
                                                                location: viewModel.selectedLocation.value,
                                                                address: viewModel.address.value,
                                                                zipCode: viewModel.zipCode.value)
            self.show(viewController, sender: nil)
        }
    }
    
    private func handleRedirectionScreensForNotificationSettings(row: Int) {
        guard row == 0 else { return }
        let viewController = SettingsNotificationViewController(frequency: viewModel.notifFrequency.value)
        self.show(viewController, sender: nil)
    }
    
    private func handleRedirectionScreensForAccountSettings(row: Int) {
        let viewController = SettingsAccountViewController()
        viewController.settingsAccountType = row == 0 ? .Pause : .Delete
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true, completion: nil)
    }
}
