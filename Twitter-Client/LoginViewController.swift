//
//  LoginViewController.swift
//  Twitter-Client
//
//  Created by Haider Khan on 10/29/16.
//  Copyright © 2016 ZkHaider. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import Material

class LoginViewController: UIViewController {

    @IBOutlet weak var twitterBirdImage: UIImageView!
    
//    @IBOutlet weak var emailTextField: TextField!
//    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var loginButton: RaisedButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        twitterBirdImage.image = UIImage.gifWithName("twitter_icon")
        
        // Prepare views
//        prepareEmailTextField()
//        preparePasswordTextField()
        prepareLoginButton()
    }
    
    @objc func emailCanceled() {
//        emailTextField.text = ""
//        emailTextField.endEditing(true)
    }

    @objc func passwordCanceled() {
//        passwordTextField.text = ""
//        passwordTextField.endEditing(true)
    }
    
    @objc func loginPressed() {
        
        TwitterClient.instance.loginWithCompletion(completion: { (user, error) in
         
            if user != nil {
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.switchControllers()
                
            } else {
                
                // Something went wrong!
            }
        })
    }

}

extension LoginViewController {
    
    /** UNCOMMENT IF YOU NEED EMAIL OR PASSWORD TEXTFIELDS **/
    
//    internal func prepareEmailTextField() {
//        
//        emailTextField.placeholder = "Email"
//        emailTextField.isClearIconButtonEnabled = true
//        emailTextField.delegate = self
//        
//        // Set a target on the clear button
//        emailTextField.clearIconButton?.addTarget(self, action: #selector(emailCanceled), for: .touchUpInside)
//    }
//    
//    internal func preparePasswordTextField() {
//        
//        passwordTextField.placeholder = "Password"
//        passwordTextField.isClearIconButtonEnabled = true
//        passwordTextField.delegate = self
//        
//        // Set a target on the clear button
//        passwordTextField.clearIconButton?.addTarget(self, action: #selector(passwordCanceled), for: .touchUpInside)
//    }
    
    internal func prepareLoginButton() {
        
        loginButton.tintColor = Color.white
        loginButton.backgroundColor = Color.blue.base
        loginButton.layer.cornerRadius = 4
        loginButton.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
    }
    
}

extension LoginViewController: TextFieldDelegate {
    
    /// Executed when the 'return' key is pressed when using the emailField.
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Email textfield
        if (textField.tag == 1) {
            print("Emailed")
        } else if (textField.tag == 2) {
            print("Password")
        }
        
        return true
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        (textField as? ErrorTextField)?.isErrorRevealed = false
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        return true
    }
    
    public func textField(textField: UITextField, didChange text: String?) {
        
    }
    
    public func textField(textField: UITextField, willClear text: String?) {
        
    }
    
    public func textField(textField: UITextField, didClear text: String?) {
        
    }
    
}

protocol LoginDelegate {
    func onUserAuthorized()
}
