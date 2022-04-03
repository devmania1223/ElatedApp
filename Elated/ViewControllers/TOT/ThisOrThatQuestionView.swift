//
//  ThisOrThatQuestionView.swift
//  Elated
//
//  Created by John Lester Celis on 4/9/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
protocol ThisOrThatQuestionViewDelegate: AnyObject {
    func didSelectBubble(_ bubbleView: EL_BubbleView?, with position: CGFloat, bubbles: EL_BubblesView)
    func nextPage()
}
class ThisOrThatQuestionView: UIView {
    weak var delegate: ThisOrThatQuestionViewDelegate?
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var bubbles: EL_BubblesView!
    var choices: [String] = []
    var otherChoices: [TOTOtherChoices] = []
    var selectedPreferences = [String]()

    override init(frame: CGRect) {
      super.init(frame: frame)
      self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      self.commonInit()
    }

    private func commonInit() {

    }
    
    func setupView() {
        bubbles.dataSource = self
        bubbles.delegate = self
        bubbles.initializeBubblesView()
        bubbles.springAnimation(duration: 1.0, depth: 258)
        UserDefaults.standard.setValue(choices, forKey: UserDefaults.Key.totChoices)
    }
}

extension ThisOrThatQuestionView: EL_BubblesViewDataSource, EL_BubblesViewDelegate {
    
    func getBubbles() -> MDL_Bubbles {
        var bubbles = MDL_Bubbles(identifier: "", text: "", bubbles: [MDL_Bubble]())
        for mPreference in choices {
            bubbles.bubbles.append(MDL_Bubble(identifier: mPreference, title: mPreference))
//            if(!selectedPreferences.contains(mPreference)) {
//                bubbles.bubbles.append(MDL_Bubble(identifier: mPreference, title: mPreference))
//            }
        }
        return bubbles
    }
    
    func selectedBubble(bubble: MDL_Bubble?, trigger: EL_BubblesView.BubbleTrigger) {
        if let bubble = bubble {
            selectedPreferences.append(bubble.identifier)
            if bubble.identifier.contains("Other") {
                for otherChoice in otherChoices {
                    if otherChoice.totChoices.count != 0 {
                        choices = otherChoice.totChoices

                            if otherChoice.totOtherChoice.count != 0 {
                            for otherChoice in otherChoice.totOtherChoice {
                                if otherChoice.totOtherChoice.count != 0 {
                                    otherChoices = [otherChoice]
                                }
                            }
                        }
                    }
                }
                let userDef = UserDefaults.standard.object(forKey: UserDefaults.Key.totChoices) as? [String]
                if userDef != choices {
                    self.setupView()
                } else {
                    //next page
                    print("next page")
                    self.delegate?.nextPage()
                }
            } else {
                //Next Page
                self.delegate?.nextPage()
            }
            

        } else {
            print(">>> Something went wrong with music preference id: ", bubble?.identifier ?? "Unkonwn bubble")
        }
    }
    
    func dragBubble(bubbleView: EL_BubbleView?, with position: CGFloat) {
        self.delegate?.didSelectBubble(bubbleView, with: position, bubbles: self.bubbles)
    }
}
