//
//  AuthViewController.swift
//  Spotify_Music
//
//  Created by Mallikharjun kakarla on 09/12/23.
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {

    private let webView:WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    public var completion:((Bool)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemGreen
        view.addSubview(webView)
        webView.navigationDelegate = self
        
        guard let url = AuthManager.shared.signInUrl else {
            return
        }
        webView.load(URLRequest(url: url))
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        //Exchange the code for access token
        let components = URLComponents(string: url.absoluteString)
        
        guard let code = components?.queryItems?.first(where: {$0.name=="code"})?.value else {
            return
        }
        print(code)
    }
}
