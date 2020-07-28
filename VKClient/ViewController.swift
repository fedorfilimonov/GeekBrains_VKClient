//
//  ViewController.swift
//  VKClient
//
//  Created by Федор Филимонов on 02.07.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loginPageScrollView: UIScrollView!
    
    @IBOutlet weak var appNameTitle: UILabel!
    
    @IBOutlet weak var loginField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginActionButton: UIButton!
    
    @IBOutlet private var loadingBar: UIView!
    
    @IBAction func LogInActionButton(_ sender: UIButton) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        loginPageScrollView.addGestureRecognizer(tapGesture)
        
    }
    
    // Реализация индикатора загрузки
    var dot1: UIView = UIView()
    var dot2: UIView = UIView()
    var dot3: UIView = UIView()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initiateLoadingBar()
        
    }
    
    func initiateLoadingBar() {
        dot1.frame = CGRect(x: (view.frame.width - 50) / 2, y: view.frame.height - 350, width: 10, height: 10)
        dot1.backgroundColor = .black
        dot1.layer.cornerRadius = dot1.bounds.width / 2
        dot1.alpha = 0.5
        
        view.addSubview(dot1)
        
        dot2.frame = CGRect(x: (view.frame.width) / 2, y: view.frame.height - 350, width: 10, height: 10)
        dot2.backgroundColor = .black
        dot2.layer.cornerRadius = dot2.bounds.width / 2
        dot2.alpha = 0.5
        
        view.addSubview(dot2)
        
        dot3.frame = CGRect(x: (view.frame.width - 25) / 2, y: view.frame.height - 350, width: 10, height: 10)
        dot3.backgroundColor = .black
        dot3.layer.cornerRadius = dot1.bounds.width / 2
        dot3.alpha = 0.5
        
        view.addSubview(dot3)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func hideKeyboard() {
        loginPageScrollView.endEditing(true)
    }
    
    private func checkLoginInfo() -> Bool {
        guard let loginText = loginField.text else { return false }
        guard let pwdText = passwordField.text else { return false }
        
        if loginText == "admin", pwdText == "12345" {
            print("Авторизация прошла успешно")
            return true
        }
        else {
            print("Авторизация не удалась")
            return false
        }
    }
    
    private func animateLoadingBar() -> Bool {
        UIView.animate(withDuration: 1.8,
                       delay: 1.0,
                       options: [.repeat, .autoreverse],
                       animations:
            {self.dot1.alpha = 1})
        
        UIView.animate(withDuration: 1.8,
                       delay: 2.5,
                       options: [.repeat, .autoreverse],
                       animations:
            {self.dot2.alpha = 1})
        
        UIView.animate(withDuration: 1.8,
                       delay: 2.5,
                       options: [.repeat, .autoreverse],
                       animations:
            {self.dot3.alpha = 1})
        
        return true
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {

        if identifier == "LogInCorrectSegue" {
            if checkLoginInfo() {
                if animateLoadingBar () {
                    return true
                }
            }
            else {
                showLoginError()
                return false
            }
        }

        return true
    }
    
    private func showLoginError() {
        let alert = UIAlertController(title: "Ошибка!", message: "Логин и/или пароль не верны", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
