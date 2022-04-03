//
//  ChatFloatingViewController.swift
//  Elated
//
//  Created by Marlon on 11/28/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class ChatFloatingViewController: UIViewController {

    let window = ChatFloatingButtonWindow()

    let chatButton: UIButton = {
        let button = UIButton()
        let placeholder = #imageLiteral(resourceName: "Icon-me-small")
        button.setImage(placeholder, for: .normal)
        button.backgroundColor = .palePurplePantone
        button.layer.shadowColor = UIColor.ssGray.cgColor
        button.layer.shadowRadius = 1
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize.zero
        button.cornerRadius = 25
        button.autoresizingMask = []
        button.sizeToFit()

        let icon = UIImageView(image: #imageLiteral(resourceName: "icon-notification-chat"))
        icon.cornerRadius = 7.5
        icon.clipsToBounds = true
        
        button.addSubview(icon)
        icon.frame = CGRect(origin: CGPoint(x: 35, y: 35),
                            size: CGSize(width: 15, height: 15))
        
        return button
    }()

    lazy var chatView: UIView = {
        let view = UIView()
        view.addSubview(chatButton)
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        window.windowLevel = UIWindow.Level(rawValue: CGFloat.greatestFiniteMagnitude)
        window.isHidden = false
        window.rootViewController = self

        chatButton.frame = CGRect(origin: CGPoint(x: self.view.frame.midX, y: self.view.frame.midY + 50),
                              size: CGSize(width: 50, height: 50))
    
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow(note:)),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
    }

    override func loadView() {
        self.view = chatView
        window.button = chatButton

        let panner = UIPanGestureRecognizer(target: self, action: #selector(panDidFire(panner:)))
        chatButton.addGestureRecognizer(panner)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        snapButtonToPosition()
    }

    @objc func panDidFire(panner: UIPanGestureRecognizer) {
        let offset = panner.translation(in: view)
        panner.setTranslation(CGPoint.zero, in: view)
        var center = chatButton.center
        center.x += offset.x
        center.y += offset.y
        chatButton.center = center

        if panner.state == .ended || panner.state == .cancelled {
            UIView.animate(withDuration: 0.3) {
                self.snapButtonToPosition()
            }
        }
    }

    @objc func keyboardDidShow(note: NSNotification) {
        window.windowLevel = UIWindow.Level(rawValue: 0)
        window.windowLevel = UIWindow.Level(rawValue: CGFloat.greatestFiniteMagnitude)
    }

    private func snapButtonToPosition() {
        var bestSocket = CGPoint.zero
        var distanceToBestSocket = CGFloat.infinity
        let center = chatButton.center
        for position in allowedSnapPositions {
            let distance = hypot(center.x - position.x, center.y - position.y)
            if distance < distanceToBestSocket {
                distanceToBestSocket = distance
                bestSocket = position
            }
        }
        chatButton.center = bestSocket
    }

    private var allowedSnapPositions: [CGPoint] {
        let buttonSize = chatButton.bounds.size
        let rect = view.bounds.insetBy(dx: 4 + buttonSize.width / 2, dy: 4 + buttonSize.height / 2)
        let sockets: [CGPoint] = [
            CGPoint(x: rect.minX, y: rect.midY),
            CGPoint(x: rect.maxX, y: rect.midY),
            CGPoint(x: rect.minX, y: rect.minY + 50),
            CGPoint(x: rect.minX, y: rect.maxY),
            CGPoint(x: rect.maxX, y: rect.minY + 50),
            CGPoint(x: rect.maxX, y: rect.maxY)
        ]
        return sockets
    }

}

class ChatFloatingButtonWindow: UIWindow {

    var button: UIButton?

    init() {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = nil
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let button = button else { return false }
        let buttonPoint = convert(point, to: button)
        return button.point(inside: buttonPoint, with: event)
    }

}
