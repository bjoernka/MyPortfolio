//
//  NewsDetail.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 24/5/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit
import WebKit

class NewsDetail: UIViewController, WKNavigationDelegate  {

    var webView = WKWebView()
    
    var urlAsString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        // 1
        let url = URL(string: urlAsString)!
        webView.load(URLRequest(url: url))

//
//        // 2
//        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
//        toolbarItems = [refresh]
//        navigationController?.isToolbarHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func setupView() {
        
        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
}
