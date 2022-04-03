//
//  EL_BubblesView.swift
//  Elated
//
//  Created by admin on 5/29/20.
//  Copyright © 2020 elatedteam. All rights reserved.
//

import Foundation
import UIKit
import Lottie

protocol EL_BubblesViewDataSource {
    func getBubbles() -> MDL_Bubbles
}

protocol EL_BubblesViewDelegate {
    func selectedBubble(bubble: MDL_Bubble?, trigger: EL_BubblesView.BubbleTrigger)
    func dragBubble(bubbleView: EL_BubbleView?, with position: CGFloat)
}

class EL_BubblesView: UIView {
    
    enum BubbleTrigger: Int {
        case unknown
        case flickLeft
        case flickRight
        case tap
        case tapHold
        case tapHoldHold
    }
    
    static let flickLeftThreshold: CGFloat = 50.0
    static let flickRightThreshold: CGFloat = 300.0 // goog threshhold for all device
    
    var dataSource: EL_BubblesViewDataSource?
    var delegate: EL_BubblesViewDelegate?
    
    var bubbles: MDL_Bubbles!
    var bubbleViews = [EL_BubbleView]()
    
    private var animator: UIDynamicAnimator!
    private var collisionBorder: UICollisionBehavior!
    private var collisionBubbles: UICollisionBehavior!
    private var behavior: UIDynamicItemBehavior!
    private var snap: UISnapBehavior?
    private var draggingBubble: EL_BubbleView?
    private var bubbleWasDragged: Bool = false
    
    private var bubbleDragThreshold: CGFloat = 10.0
    private var touchBeganLocation = CGPoint.zero
    
    
    private let minFloatingMagnitude: CGFloat = 40 // floating speed (old value 10)
    private let floatingMagnitudeDelta: CGFloat = 20.0 // additional floating speed (old value 5.0)
    private var floatingMagnitude: CGFloat {
        get {
            // Magnitude from 40 to 60
            return minFloatingMagnitude + CGFloat(arc4random() % 100) / 100.0 * floatingMagnitudeDelta
        }
    }
    private var tutorialMode: Bool = false
    private var triggerType: BubbleTrigger = .unknown
    
    func initializeBubblesView(tutorialMode: Bool = false) {
        
        self.tutorialMode = tutorialMode
        
        // Initialize physics
        animator = UIDynamicAnimator(referenceView: self)
        
        collisionBorder = UICollisionBehavior(items: [])
        collisionBorder.translatesReferenceBoundsIntoBoundary = true
        collisionBorder.collisionDelegate = self
        
        collisionBubbles = UICollisionBehavior(items: [])
        collisionBubbles.translatesReferenceBoundsIntoBoundary = false
        collisionBubbles.collisionDelegate = self
        
        behavior = UIDynamicItemBehavior(items: [])
        behavior.elasticity = 0.5
        behavior.friction = 0.0
        behavior.allowsRotation = false
        behavior.resistance = 0.0
        behavior.angularResistance = 0.0
        behavior.action = {
            // Do not let the bubbles stop
            for bubble in self.bubbleViews {
                if self.behavior.linearVelocity(for: bubble).equalTo(CGPoint.zero) {
                    self.setRandomVelocity(forItem: bubble)
                }
            }
        }
        
        animator.addBehavior(collisionBorder)
        animator.addBehavior(collisionBubbles)
        animator.addBehavior(behavior)
        
        // Initialize bubbles
        createBubbles()
        
        let lpg = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        lpg.numberOfTouchesRequired = 1
        lpg.minimumPressDuration = 0
        self.addGestureRecognizer(lpg)
        self.isUserInteractionEnabled = true
    }
    
    func setRandomVelocity(forItem item: UIDynamicItem) {
        var angle = CGFloat(arc4random() % 1000) / 1000.0 * .pi * 2
        if angle == 0 {
            angle = .pi / 2
        }
        
        let magnitude = floatingMagnitude
        let velocity = CGPoint(x: cos(angle) * magnitude, y: sin(angle) * magnitude)
//        let velocity = CGPoint(x: 0, y: sin(angle) * magnitude)
        let currentVelocity = behavior.linearVelocity(for: item)
        behavior.addLinearVelocity(velocity - currentVelocity, for: item)
    }

    private func createBubbles() {
        self.bubbles = self.dataSource?.getBubbles() ?? MDL_Bubbles(identifier: "", text: "", bubbles: [MDL_Bubble]())
        // Remove all existing bubbles
        removeAllBubbles()
        
        guard !bubbles.bubbles.isEmpty else {
            return
        }
        
        // Order bubbles so longest titles are first (first bubbles are bigger)
        let orderedBubbles = bubbles.bubbles.sorted { (bubble1, bubble2) -> Bool in
            return bubble1.title.count >= bubble2.title.count
        }
        
        // Try to create bubbles
        let maxAttemptsCount = 20
        let minBubbleRadius: CGFloat = 100
        let bubbleRadiusStep: CGFloat = 0
        var currentBubbleRadius: CGFloat = 100
        var currentAttempt = 0
        var canPlaceAll = true
        
        repeat {
            currentAttempt += 1
            canPlaceAll = true
            
            for bubble in orderedBubbles {
                let newBubble = addBubble(bubble, minRadius: minBubbleRadius, maxRadius: currentBubbleRadius, radiusStep: 1, maxAttemptsCount: 50, forced: currentAttempt == maxAttemptsCount)
                guard newBubble != nil else {
                    currentBubbleRadius = max(minBubbleRadius, currentBubbleRadius - bubbleRadiusStep)
                    canPlaceAll = false
                    removeAllBubbles()
                    break
                }
            }
        } while currentAttempt <= maxAttemptsCount && !canPlaceAll
        
        if !canPlaceAll {
            print("WARNING: Cannot place bubbles")
        }
    }
    
    func addOneBubble(bubble: MDL_Bubble) -> Bool {
        if let _ = addBubble(bubble, minRadius: 100, maxRadius: 100, radiusStep: 1, maxAttemptsCount: 50, forced: true) {
            return true
        } else {
            return false
        }
    }
    
    func removeOneBubble(bubble: MDL_Bubble) {
        if let bubbleView = bubbleViews.first(where: { $0.bubble?.identifier == bubble.identifier }) {
            bubbleViewWasDestroyed(bubbleView)
        }
    }

    private func removeAllBubbles() {
        for bubbleView in bubbleViews {
            removeBubbleViewFromPhysics(bubbleView)
        }
        bubbleViews.removeAll()
    }
    
    private func removeBubbleViewFromPhysics(_ bubbleView: EL_BubbleView) {
        collisionBorder.removeItem(bubbleView)
        collisionBubbles.removeItem(bubbleView)
        behavior.removeItem(bubbleView)
        bubbleView.removeFromSuperview()
    }
    
    private func addBubble(_ bubble: MDL_Bubble, minRadius: CGFloat, maxRadius: CGFloat, radiusStep: CGFloat, maxAttemptsCount: Int, forced: Bool) -> EL_BubbleView? {
        var currentAttempt = 0
        var currentRadius = maxRadius
        var bubbleView: EL_BubbleView? = nil
        
        repeat {
            currentAttempt += 1
            
            let minX = currentRadius / 2
            let minY = currentRadius / 2
            let dX = self.frame.size.width - currentRadius
            let dY = self.frame.size.height - currentRadius
            
            let center = CGPoint(x: minX + CGFloat(arc4random() % UInt32(dX)),
                                 y: minY + dY)
//                                 y: minY + CGFloat(arc4random() % UInt32(dY)))
            guard (currentAttempt == maxAttemptsCount && forced) || canPlaceBubbleAtPoint(center, withRadius: currentRadius) else {
                currentRadius = max(minRadius, currentRadius - radiusStep)
                continue
            }
            
            // Create new bubble
            bubbleView = EL_BubbleView(frame: CGRect(x: 0, y: 0, width: currentRadius, height: currentRadius))
            bubbleView!.translatesAutoresizingMaskIntoConstraints = false
            bubbleView!.center = center
            bubbleView!.bubble = bubble
            bubbleView?.delegate = self
            
            if tutorialMode {
                let animation = AnimationView(name: "tap-gesture")
                animation.contentMode = .scaleAspectFit
                animation.loopMode = .loop
                animation.backgroundBehavior = .pauseAndRestore
                animation.play()
                animation.isHidden = true
                bubbleView?.addSubview(animation)
                animation.snp.makeConstraints { make  in
                    make.width.height.equalTo(currentRadius * 2)
                    make.top.equalToSuperview()
                    make.centerX.equalToSuperview().offset(currentRadius / 2)
                }
            }
                        
            // Add to physics world
            self.addSubview(bubbleView!)
            collisionBorder.addItem(bubbleView!)
            collisionBubbles.addItem(bubbleView!)
            behavior.addItem(bubbleView!)
            setRandomVelocity(forItem: bubbleView!)
            
            bubbleViews.append(bubbleView!)
            
        } while currentAttempt <= maxAttemptsCount && bubbleView == nil
        
        return bubbleView
    }



    private func canPlaceBubbleAtPoint(_ point: CGPoint, withRadius radius: CGFloat) -> Bool {
        for bubbleView in bubbleViews {
            let bubbleRadius = bubbleView.frame.size.width / 2
            if point.distanceToPoint(bubbleView.center) < bubbleRadius + radius {
                return false
            }
        }
        
        return true
    }



    private func bubble(atPoint point: CGPoint) -> EL_BubbleView? {
        for bubbleView in bubbleViews {
            let bubbleRadius = bubbleView.frame.size.width / 2
            if point.distanceToPoint(bubbleView.center) < bubbleRadius {
                return bubbleView
            }
        }
        
        return nil
    }


    private func bringBubbleToFront(_ bubbleView: EL_BubbleView) {
        self.bringSubviewToFront(bubbleView)
    }
    
}

extension EL_BubblesView: UICollisionBehaviorDelegate {
    @objc func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        if self.behavior.linearVelocity(for: item1).length() < minFloatingMagnitude + floatingMagnitudeDelta {
            updateRicochetVelocity(forItem: item1, toSurfaceWithNormal: item1.center - p)
        }
        
        if self.behavior.linearVelocity(for: item2).length() < minFloatingMagnitude + floatingMagnitudeDelta {
            updateRicochetVelocity(forItem: item2, toSurfaceWithNormal: item2.center - p)
        }
        
    }
    
    
    
    @objc public func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        if self.behavior.linearVelocity(for: item).length() < minFloatingMagnitude + floatingMagnitudeDelta {
            updateRicochetVelocity(forItem: item, toSurfaceWithNormal: item.center - p)
        }
        
    }
    
    func updateRicochetVelocity(forItem item: UIDynamicItem, toSurfaceWithNormal surfaceNormal: CGPoint) {
        let currentVelocity = behavior.linearVelocity(for: item)
        let newMagnitude = floatingMagnitude
        
        let nSurfaceNormal = surfaceNormal.normalized()
        let nCurrentVelocity = currentVelocity.normalized()
        
        // Calculate reflection vector
        let dp =  nCurrentVelocity.dotProduct(withPoint: nSurfaceNormal)
        var reflection = nCurrentVelocity - nSurfaceNormal * 2 * dp
        
        // Avoid vertical or horizontal reflections
        if reflection.x == 0.0 || reflection.y == 0.0 ||
            reflection.x / reflection.y < 0.2 || reflection.y / reflection.x < 0.2 {
            reflection.x += nSurfaceNormal.x
            reflection.y += nSurfaceNormal.y
            reflection = reflection.normalized()
        }
        
        let newVelocity = reflection * newMagnitude
        
        behavior.addLinearVelocity(newVelocity - currentVelocity, for: item)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UIGestureRecognizer) {
        
        let panGR = gestureRecognizer as! UILongPressGestureRecognizer
        var touchPoint = panGR.location(in: self)
        
        if panGR.state == .began {
            // Find bubble which was touched
            draggingBubble = bubble(atPoint: touchPoint)
            guard draggingBubble != nil else {
                return
            }

            touchBeganLocation = touchPoint
            
            // Create snap
            if snap == nil {
                // Create snap
                snap = UISnapBehavior(item: draggingBubble!, snapTo: touchPoint)
                animator.addBehavior(snap!)
                
                // Views order
                bringBubbleToFront(draggingBubble!)
            }
            
            // Start filling
            if bubbles.triggers.contains(.hold) {
                draggingBubble!.isFilling = true
            }
            draggingBubble!.isSelected = true
        }
        else if panGR.state == .changed {
            guard draggingBubble != nil else {
                return
            }
            
            // Check threshold
            guard touchPoint.distanceToPoint(touchBeganLocation) >= bubbleDragThreshold || bubbleWasDragged else {
                return
            }
            
            // Start dragging
            if !bubbleWasDragged {
                draggingBubble!.isSelected = false
                draggingBubble!.isDragging = true
                draggingBubble!.isFilling = false
                bubbleWasDragged = true
                
                // Disable borders collision
//                collisionBorder.removeItem(draggingBubble!)
//                collisionBubbles.removeItem(draggingBubble!)
            }
            
            // Don't let dragging to top or bottom border
            let bubbleRadius = draggingBubble!.bounds.size.width / 2
            touchPoint.y = min(max(touchPoint.y, bubbleRadius), self.bounds.size.height - bubbleRadius)
            
            snap?.snapPoint = touchPoint
//            updateLikeDislikeButtons(withTouchPoint: touchPoint)
        }
        else if panGR.state == .ended || panGR.state == .cancelled {
            guard draggingBubble != nil else {
                return
            }
            
            // Destroy snap
            if let snap = snap {
                animator.removeBehavior(snap)
                self.snap = nil
            }
            
            // Was dragged
            if bubbleWasDragged {
                draggingBubble!.isDragging = false
                bubbleWasDragged = false
                collisionBorder.addItem(draggingBubble!)
                
                let location = gestureRecognizer.location(in: self)
                
                dragBubble(location.x)
                
            } else { // Was tapped
                
                if bubbles.triggers.contains(.tap) ||
                    (bubbles.triggers.contains(.hold) && draggingBubble!.isFilled) {
                    explodeBubble(trigger: draggingBubble!.isFilled ? .tapHold : .tap)
                } else {
                    draggingBubble!.isFilling = false
                }
            }
            
            draggingBubble = nil
        }
    }
}

extension EL_BubblesView: EL_BubbleViewDelegate {
    
    func bubbleViewDidFinishFilling(_ bubbleView: EL_BubbleView) {
        explodeBubble(bubbleView, trigger: .tapHoldHold)
    }
    
    private func bubbleViewWasDestroyed(_ bubbleView: EL_BubbleView) {
        removeBubbleViewFromPhysics(bubbleView)
        removeBubbleViewFromArray(bubbleView)
        
    }
    
    private func removeBubbleViewFromArray(_ bubbleView: EL_BubbleView) {
        
        if let index = bubbleViews.firstIndex(where: { $0 == bubbleView }) {
            bubbleViews.remove(at: index)
        }
    }
    
    private func dragBubble(_ position: CGFloat) {
        guard let bubbleView = draggingBubble else { return }
                
        // Destroy bubble
//        removeBubbleViewFromArray(bubbleView)
        self.delegate?.dragBubble(bubbleView: bubbleView, with: position)
    }
    
    private func explodeBubble(trigger: BubbleTrigger) {
        guard let bubbleView = draggingBubble else { return }
        bubbleView.animateStopFilling()
        explodeBubble(bubbleView, trigger: trigger)
    }
    
    func explodeBubble(_ bubbleView: EL_BubbleView, trigger: BubbleTrigger) {
        let bubble = bubbleView
        // Destroy snap
        if let snap = snap {
            animator.removeBehavior(snap)
            self.snap = nil
        }
        
        draggingBubble = nil
        bubbleWasDragged = false
        
        // Destroy bubble
        removeBubbleViewFromArray(bubble)
        bubble.animateExplosion(completion: { [weak self] (sender) in
            // Cleanup bubble
            self?.delegate?.selectedBubble(bubble: sender.bubble, trigger: trigger)
            self?.removeBubbleViewFromPhysics(bubbleView)
        })
    }    
}

extension CGPoint {
    
    func distanceToPoint(_ point: CGPoint) -> CGFloat {
        let dx = point.x - x
        let dy = point.y - y
        return CGFloat(sqrtf(Float(dx * dx + dy * dy)))
    }
    
    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    func length() -> CGFloat {
        return CGFloat(sqrtf(Float(x * x + y * y)))
    }
    func normalized() -> CGPoint {
        let len = length()
        return CGPoint(x: x / len, y: y / len)
    }
    func dotProduct(withPoint point: CGPoint) -> CGFloat {
        return x * point.x + y * point.y
    }
    
    static func * (left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x * right, y: left.y * right)
    }
}
