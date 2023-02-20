//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    //Loginボタン押下時のアクション
    @IBAction func loginPressed(_ sender: UIButton) {
        //emailTextfieldとpasswordTextfieldの情報を使用し
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            //FirebaseAuthenticationデータベースに保管されているmailとpasswordを照合しサインイン
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    //errorがなければchatVireController画面に行く
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
        }
        
    }
}
