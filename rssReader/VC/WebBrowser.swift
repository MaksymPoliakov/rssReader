//
//  FeedDetailController.swift
//  rssReader
//
//  Created by Maksym Poliakov on 23.10.16.
//  Copyright © 2016 Maksym Poliakov. All rights reserved.
//

import UIKit


class WebBrowser: UIViewController, UITextFieldDelegate, UIWebViewDelegate {

//    var webView = WKWebView()
    var webView = UIWebView()
    var progressView: UIProgressView!
    var urlString: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.webView.navigationDelegate = self

        setupViews()

    }
    
    func setupViews() {
        view.backgroundColor = .white
        progressView = UIProgressView(progressViewStyle: .default)
        view.insertSubview(webView, belowSubview: progressView)
        webView.frame = self.view.bounds
//        view.addConstraintsWithFormat(format: "V:|[v0(30)]-0-|", views: barView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let url = urlString {
            loadUrlFrom(url)
        }
    }
    
    func loadUrlFrom(_ string: String) {
        
        let urlString = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlString!)
        let request = URLRequest(url: url!)
//        self.webView.load(request)
        self.webView.loadRequest(request)
    }
    
}

