//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth


class RegisterViewController: UIViewController {
    
    
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    //テキストフィールド内の文字を目隠し状態で入力する設定はユーティリティの「SequreTextEntry」で設定可能
    
    
    
    //Registerボタン押下時アクション
    //登録した情報はGoogleによって安全に暗号化され大切に保管
    @IBAction func registerPressed(_ sender: UIButton) {
        //emailTextfieldとpasswordTextfieldの情報を
        guard let email = emailTextfield.text,let password = passwordTextfield.text else { return }
            //Firebaseに取り込み新規ユーザー登録するため一度アカウント情報を登録する
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                //passwordが６文字以上ない場合はerrorとなりiphoneの各言語にローカライズされたエラー文を表示
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    //errorがなければchatVireController画面に行く
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
            }
        }
        
    }

