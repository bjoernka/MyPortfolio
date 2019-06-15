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

    @IBOutlet weak var webView: WKWebView!
    
    var urlAsString: String = ""
    
//    override func loadView() {
//        webView = WKWebView()
//        webView.navigationDelegate = self
//        view = webView
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
}
