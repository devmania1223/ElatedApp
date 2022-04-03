//
//  SelectionLanguageTableViewCell.swift
//  Elated
//
//  Created by John Lester Celis on 2/1/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class SelectionLanguageTableViewCell: UITableViewCell {
    
    static let identifier = "SelectionLanguageTableViewCell"
    
    @IBOutlet weak var checkboxImageView: UIImageView!
    static let nib:UINib = {
      return UINib(nibName: "\(SelectionLanguageTableViewCell.self)", bundle: nil)
    }()

    @IBOutlet weak var languageLabel: UILabel!
    
    override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
        self.selectionStyle = .none
    }
    
    func configureCell(_ title: String, checked: Bool) {
        print(title)
        languageLabel.text = title
        checkboxImageView.image = !checked
            ? #imageLiteral(resourceName: "checkboxBox").withRenderingMode(.alwaysTemplate)
            : #imageLiteral(resourceName: "checkboxCheck").withRenderingMode(.alwaysTemplate)
    }
    
}
