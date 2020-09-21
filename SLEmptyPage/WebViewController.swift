//
//  WebViewController.swift
//  SLEmptyPage
//
//  Created by 孙梁 on 2020/9/21.
//  Copyright © 2020 SL. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: URL(string: "https://www.baidu.com")!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 5))
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        webView.showEmptyView()
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webView.hideEmptyView()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.hideEmptyView()
    }
}
