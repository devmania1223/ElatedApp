//
//  FavMyFavTableViewCell.swift
//  Elated
//
//  Created by admin on 6/21/20.
//  Copyright © 2020 elatedteam. All rights reserved.
//

import UIKit

class FavMyFavTableViewCell: UITableViewCell {

    @IBOutlet weak var m_imgUser: UIImageView!
    @IBOutlet weak var m_lblUser: UILabel!
    @IBOutlet weak var m_lblLocation: UILabel!
    @IBOutlet weak var m_lblBriefcase: UILabel!
    
    @IBOutlet weak var m_btnDelete: UIButton!
    @IBOutlet weak var m_btnSendInvite: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
