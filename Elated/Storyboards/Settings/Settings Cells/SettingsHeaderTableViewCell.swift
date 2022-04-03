//
//  SettingsHeaderTableViewCell.swift
//  Elated
//
//  Created by Yiel Miranda on 3/22/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class SettingsHeaderTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.addCharacterSpacing(kernValue: 0.3)
        }
    }
    
    static let identifier = "SettingsHeaderCell"
    
    //MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Custom
    
    func setupCell(title: String) {
        titleLabel.text = title
    }

}
