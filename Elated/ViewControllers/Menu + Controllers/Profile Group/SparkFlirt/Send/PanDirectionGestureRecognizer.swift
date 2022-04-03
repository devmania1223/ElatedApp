//
//  PanDirectionGestureRecognizer.swift
//  Elated
//
//  Created by Rey Felipe on 7/28/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//
// For creating single direction pan gestures:
// http://stackoverflow.com/questions/7100884/uipangesturerecognizer-only-vertical-or-horizontal
import UIKit
import UIKit.UIGestureRecognizerSubclass


/// Necessary when we have a gesture recognizer attached to a view within a scroll view.
/// This recognizer needs to set its state to cancelled if the initial velocity is in the
/// wrong direction. This allows, say, a vertical gesture recognizer to be added to a view
/// within a horizontally scrolling scrollview.
class PanDirectionGestureRecognizer: UIPanGestureRecognizer {
    
    enum PanVerticalDirection {
        case either
        case up
        case down
    }

    enum PanHorizontalDirection {
        case either
        case left
        case right
    }

    enum PanDirection {
        case vertical(PanVerticalDirection)
        case horizontal(PanHorizontalDirection)
    }

    let direction: PanDirection
    
    init(direction: PanDirection, target: AnyObject, action: Selector) {
        self.direction = direction
        super.init(target: target, action: action)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        if state == .began {
            let vel = velocity(in: view)
            switch direction {
            
            // expecting horizontal but moving vertical, cancel
            case .horizontal(_) where abs(vel.y) > abs(vel.x):
                state = .cancelled
                
            // expecting vertical but moving horizontal, cancel
            case .vertical(_) where abs(vel.x) > abs(vel.y):
                state = .cancelled
                
            // expecting horizontal and moving horizontal
            case .horizontal(let hDirection):
                switch hDirection {
                
                // expecting left but moving right, cancel
                case .left where vel.x > 0: state = .cancelled
                    
                // expecting right but moving left, cancel
                case .right where vel.x < 0: state = .cancelled
                default: break
                }
                
            // expecting vertical and moving vertical
            case .vertical(let vDirection):
                switch vDirection {
                // expecting up but moving down, cancel
                case .up where vel.y > 0: state = .cancelled
                    
                // expecting down but moving up, cancel
                case .down where vel.y < 0: state = .cancelled
                default: break
                }
            }
        }
    }
}
