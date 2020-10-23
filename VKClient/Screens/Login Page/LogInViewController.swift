//
//  ViewController.swift
//  VKClient
//
//  Created by Федор Филимонов on 02.07.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import UIKit
import WebKit

class LogInViewController: UIViewController {
    
    // UI
    @IBOutlet private weak var loginPageScrollView: UIScrollView!
    @IBOutlet private weak var loginField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    //MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackgroundColor()
        logIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardAddObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardRemoveObserver()
    }
    
    // MARK: - Log In Action
    
    @IBAction func loginButtonOnTapped (_ sender: Any) {
        guard let login = loginField.text, let password = passwordField.text else { return }
        
        // Passing login and password details from form to webView
        webView.evaluateJavaScript("document.querySelector('input[name=email]').value='\(login)';document.querySelector('input[name=pass]').value='\(password)';") { [weak self] (res, error) in self?.webView.isHidden = false
        }
    }
}

// MARK: - Web View extension

extension LogInViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url,
              url.path == "/blank.html",
              let fragment = url.fragment else { decisionHandler(.allow); return }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        
        print(params)
        
        guard let token = params["access_token"],
              let userIdString = params["user_id"],
              let _ = Int(userIdString) else {
            decisionHandler(.allow)
            return
        }
        
        Session.shared.token = token
        Session.shared.userId = userIdString
        
        // Action when web view form is filled in
        performSegue(withIdentifier: "LogInCorrectSegue", sender: nil)
        
        decisionHandler(.cancel)
    }
}

//MARK: - Interaction with Network
extension LogInViewController {
    
    private func logIn() {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "oauth.vk.com"
        components.path = "/authorize"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: "7565209"),
            URLQueryItem(name: "scope", value: "friends,photos,wall,groups"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.92")
        ]
        let request = URLRequest(url: components.url!)
        
        webView.load(request)
    }
}

extension LogInViewController {
    
    func keyboardAddObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        loginPageScrollView.addGestureRecognizer(tapGesture)
    }
    
    func keyboardRemoveObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setUpBackgroundColor() {
        let loginPageColor = UIColor(red: 81 / 255, green: 129 / 255, blue: 184 / 255, alpha: 1)
        view.backgroundColor = loginPageColor
    }
    
    @objc func keyboardWillShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0)
        
        loginPageScrollView.contentInset = contentInsets
        loginPageScrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        loginPageScrollView.contentInset = UIEdgeInsets.zero
        loginPageScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    @objc func hideKeyboard() {
        loginPageScrollView.endEditing(true)
    }
}
