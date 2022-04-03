//
//  SettingsTitleWithSubtitleTableViewCell.swift
//  Elated
//
//  Created by Yiel Miranda on 3/22/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class SettingsTitleWithSubtitleTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    @IBOutlet weak var bgView: UIView! {
        didSet {
            bgView.layer.borderWidth = 0.25
            bgView.layer.borderColor = UIColor.silver.cgColor
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.addCharacterSpacing(kernValue: 0.26)
        }
    }
    
    @IBOutlet weak var subtitleLabel: UILabel! {
        didSet {
            subtitleLabel.addCharacterSpacing(kernValue: 0.26)
        }
    }
    
    @IBOutlet weak var arrowRightImageView: UIImageView!
    
    static let identifier = "SettingsTitleWithSubtitleCell"
    
    //MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Custom
    
    func setupCell(title: String, subtitle: String, shouldApplyRedTint: Bool = false) {
        titleLabel.text = title
        
        subtitleLabel.text = subtitle
        
        if shouldApplyRedTint {
            titleLabel.textColor = .danger
            arrowRightImageView.tintColor = .danger
        } else {
            titleLabel.textColor = .grayColor
            arrowRightImageView.tintColor = .jet
        }
    }
}
