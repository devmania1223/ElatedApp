//
//  TermsViewController.swift
//  Elated
//
//  Created by John Lester Celis on 3/9/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import WebKit

class TermsViewController: BaseViewController {
    
    enum LinkType: String {
        case terms = "https://elated.io/tou"
        case policy = "https://elated.io/privacy"
    }
    
    internal let backButton = UIBarButtonItem.createBackButton()
        
    internal lazy var webView: WKWebView = {
      let webView = WKWebView()
      webView.translatesAutoresizingMaskIntoConstraints = false
      webView.navigationDelegate = self
      return webView
    }()
    
    internal let acceptButton: UIButton = {
        let button = UIButton()
        button.setTitle("common.accept".localized, for: .normal)
        button.backgroundColor = .elatedPrimaryPurple
        button.titleLabel?.font = .futuraBook(14)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 30
        return button
    }()
    
    init(_ type: LinkType, shouldHideAccept: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        
        self.title = type == .terms ? "legal.terms".localized : "legal.privacy".localized
        acceptButton.isHidden = shouldHideAccept
        
        if let url = URL(string: type.rawValue) {
            self.webView.load(URLRequest(url: url))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.leftBarButtonItem = backButton
        backButton.tintColor = .white
        self.setupNavigationBar(.white,
                                font: .futuraMedium(20),
                                tintColor: .white,
                                backgroundImage: #imageLiteral(resourceName: "background-header"))
        
        self.manageActivityIndicator.accept(true)
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.backgroundColor = .white
        view.addSubview(webView)
        webView.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        })
        
        view.addSubview(acceptButton)
        acceptButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(30)
            make.height.equalTo(60)
            make.left.right.equalToSuperview().inset(33)
        }
    }
    
    override func bind() {
        super.bind()
        
        acceptButton.rx.tap.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)

        backButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
}


// MARK: - WKNavigationDelegate
extension TermsViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, decidePolicyFor
                navigationAction: WKNavigationAction,
               decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    let prefix = "https"
    if let url = navigationAction.request.url {
      if url.absoluteString.hasPrefix(prefix) {
        decisionHandler(.allow)
      } else {
        decisionHandler(.cancel)
      }
    }
  }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.manageActivityIndicator.accept(false)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.manageActivityIndicator.accept(false)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.manageActivityIndicator.accept(true)
    }
    
}
