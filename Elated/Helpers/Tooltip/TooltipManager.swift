//
//  TooltipManager.swift
//  Elated
//
//  Created by Rey Felipe on 7/13/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import AMPopTip
import RxSwift
import RxCocoa

class TooltipManager {
    
    static let shared = TooltipManager()
    
    private var tips = [TooltipInfo]()
    
    private let popTip: PopTip = {
        let popTip = PopTip()
        popTip.bubbleColor = .elatedPrimaryPurple
        popTip.textColor = .white
        popTip.padding = 10
        popTip.shouldDismissOnTap = true
        popTip.shouldDismissOnTapOutside = true
        popTip.shouldDismissOnSwipeOutside = true
        popTip.font = .futuraMedium(12)
        popTip.entranceAnimation = .scale
        return popTip
    }()
    
    private var view: UIView?
    private let disposeBag = DisposeBag()
    
    private init() {
        popTip.dismissHandler = { [weak self] popTip in
            guard let self = self else { return }
            
            self.view?.removeFromSuperview()
            
            guard let _ = self.tips.first else { return }
            // remove the 1st item in the list
            self.tips.remove(at: 0)
            // should show the next tooltip
            self.showIfNeeded()
        }
    }
    
    func addTip(_ tip: TooltipInfo) {
        // check if tip is already shown or already exist in array
        guard isToolTipAlreadyShown(forTip: tip),
              (tips.first( where: { $0.tipId == tip.tipId } ) != nil) else {
            tips.append(tip)
            return
        }
    }
    
    func showIfNeeded() {
        // check if tooltip was already shown before displaying
        guard !tips.isEmpty,
              let currentTip = tips.first
        else { return }
        
        if isToolTipAlreadyShown(forTip: currentTip) {
            // Remove it from the array
            tips.remove(at: 0)
            // show the next tooltip
            showIfNeeded()
            return
        }
        
        view = UIView()
        currentTip.parentView.addSubview(view!)
        view?.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
        let tapGesture = UITapGestureRecognizer()
        view?.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind { [weak self] (recognizer) in
            guard let self = self else { return }
            // hide
            if self.popTip.isVisible {
                self.popTip.hide()
            }
        }.disposed(by: disposeBag)
        
        popTip.offset = currentTip.offset
        popTip.show(text: currentTip.tipId.text, direction: currentTip.direction, maxWidth: currentTip.maxWidth, in: currentTip.inView, from: currentTip.fromRect, duration: currentTip.duration)
        
        // set key flag to not show this again
        setToolTipShown(forTip: currentTip)
    
        currentTip.parentView.bringSubviewToFront(currentTip.inView)
    }
    
    func reInit() {
        tips.removeAll()
    }
    
    //MARK: For testing purpose only DO NOT call this function on PROD build
    func forgetAll() {
        Tooltip.allCases.forEach {
            UserDefaults.standard.removeObject(forKey: $0.key)
        }
    }
    
}

//MARK: Private Functions
extension TooltipManager {
    
    private func isToolTipAlreadyShown(forTip tip: TooltipInfo) -> Bool {
        return UserDefaults.standard.bool(forKey: tip.tipId.key)
    }
    
    private func setToolTipShown(forTip tip: TooltipInfo) {
        UserDefaults.standard.set(true, forKey: tip.tipId.key)
    }
    
}
