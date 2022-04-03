//
//  SFSparkflirtsTableViewCell.swift
//  Elated
//
//  Created by admin on 6/22/20.
//  Copyright © 2020 elatedteam. All rights reserved.
//

import UIKit

class SFSparkflirtsTableViewCell: UITableViewCell {

    @IBOutlet weak var m_csrtMeWidth: NSLayoutConstraint!
    @IBOutlet weak var m_csrtUserWidth: NSLayoutConstraint!
    
    @IBOutlet weak var m_viewTurnBubble: EL_SF_TurnBubbleView!
    @IBOutlet weak var m_btnMe: UIButton!
    @IBOutlet weak var m_lblGame: UILabel!
    @IBOutlet weak var m_lblLastPlayed: UILabel!
    
    @IBOutlet weak var m_btnUser: UIButton!
    @IBOutlet weak var m_lblUser: UILabel!
    @IBOutlet weak var m_lblLocation: UILabel!
    
    @IBOutlet weak var m_btnSendNudge: UIButton!
    
    @IBOutlet weak var m_viewAnimContainer: UIView!
    @IBOutlet var m_viewAnims: [UIView]!
    @IBOutlet var m_csrtAnimsWidth: [NSLayoutConstraint]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.animateImages()
        
    }
    
    func animateImages() {
        self.m_viewAnims[0].alpha = 0.5
        self.m_viewAnims[1].alpha = 0.5
        self.m_viewAnims[2].alpha = 0.5
        UIView.animate(withDuration: 0.5, animations: {
            self.m_viewAnims[0].alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.5, animations: {
                self.m_viewAnims[1].alpha = 1
            }) { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    self.m_viewAnims[2].alpha = 1
                }) { _ in
                    DispatchQueue.main.async {
                        self.animateImages()
                    }
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
