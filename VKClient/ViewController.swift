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
    
    @IBOutlet weak var AppNameTitle: UILabel!
    
    @IBOutlet weak var loginField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginActionButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        loginPageScrollView.addGestureRecognizer(tapGesture)
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
}


