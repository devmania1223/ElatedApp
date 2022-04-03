//
//  SFInviteTableViewCell.swift
//  Elated
//
//  Created by admin on 6/9/20.
//  Copyright © 2020 elatedteam. All rights reserved.
//

import UIKit

protocol SFInviteTableViewCellDelegate: AnyObject {
    func btnFavoriteClicked(cell: SFInviteTableViewCell)
    func btnDeleteClicked(cell: SFInviteTableViewCell)
}

class SFInviteTableViewCell: UITableViewCell {

    @IBOutlet weak var m_imgUser: UIImageView!
    @IBOutlet weak var m_viewBadgeRead: UIView!
    @IBOutlet weak var m_lblUser: UILabel!
    @IBOutlet weak var m_lblLocation: UILabel!
    @IBOutlet weak var m_btnFavorite: UIButton!
    @IBOutlet weak var m_btnDelete: UIButton!
    @IBOutlet weak var m_viewNudgeContainer: UIView!
    @IBOutlet weak var m_imgNudge: UIImageView!
    
    weak var delegate: SFInviteTableViewCellDelegate? {
        didSet {
            self.m_imgNudge.layer.removeAllAnimations()
            
            let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.duration = 1.0
            scaleAnimation.repeatCount = Float.infinity
            scaleAnimation.autoreverses = true
            scaleAnimation.fromValue = 1.0
            scaleAnimation.toValue = 1.2
            self.m_imgNudge.layer.add(scaleAnimation, forKey: "scale")
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    @IBAction func btnFavoriteClicked(_ sender: UIButton) {
        delegate?.btnFavoriteClicked(cell: self)
    }
    
    @IBAction func btnDeleteClicked(_ sender: UIButton) {
        delegate?.btnDeleteClicked(cell: self)
    }
}
