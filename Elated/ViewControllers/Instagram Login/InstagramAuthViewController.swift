//
//  InstagramAuthViewController.swift
//  Elated
//
//  Created by Marlon on 6/2/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import WebKit

class InstagramAuthViewController: BaseViewController {
    
    let viewModel = InstagramAuthViewModel()
    
    var callback: ((Bool) -> Void)?
    
    internal lazy var webView: WKWebView = {
        WKWebView.clean()
        let webView = WKWebView()
        webView.navigationDelegate = self
        
        var components = URLComponents(string: "https://api.instagram.com/oauth/authorize/")!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: Environment.instagramClientID),
            URLQueryItem(name: "redirect_uri", value: Environment.instagramURLScheme),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: "user_profile, user_media")
        ]
        
        webView.load(URLRequest(url: components.url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData))
        return webView
    }()
    
    init(_ callback: ((Bool) -> Void)?) {
        super.init(nibName: nil, bundle: nil)
        self.callback = callback
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func initSubviews() {
        super.initSubviews()
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)

        viewModel.presentAlert.subscribe(onNext: { [weak self] args in
          let (title, message) = args
          self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        viewModel.success.subscribe (onNext: { [weak self] success in
            if let nav = self?.navigationController {
                nav.popViewController(animated: true)
            } else {
                self?.dismiss(animated: true, completion: nil)
            }
            self?.callback?(success)
        }).disposed(by: disposeBag)
        
    }
    
}

extension InstagramAuthViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if navigationItem.title == nil {
            navigationItem.title = webView.title
        }
    }
    
    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.url?.absoluteString,
           let components = URLComponents(string: url),
           let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
                viewModel.code.accept(code)
        }
        
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationResponse: WKNavigationResponse,
                        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
         
        if let response = navigationResponse.response as? HTTPURLResponse, response.statusCode == 400 {
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        } 
    }
    
}
