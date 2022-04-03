//
//  SettingsTitleWithSwitchTableViewCell.swift
//  Elated
//
//  Created by Yiel Miranda on 3/22/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class SettingsTitleWithSwitchTableViewCell: UITableViewCell {
    
    var didChange: ((Bool) -> Void)?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var switchButton: UISwitch! {
        didSet {
            switchButton.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }
    }
    
    static let identifier = "SettingsTitleWithSwitchCell"
    
    //MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        switchButton.addTarget(self, action: #selector(changeState), for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //MARK: - Custom
    func setupCell(title: String, isOn: Bool) {
        titleLabel.text = title
        switchButton.isOn = isOn
    }
    
    @objc private func changeState() {
        didChange?(switchButton.isOn)
    }
    
}
