//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    let db = Firestore.firestore()
    
    //Message配列オブジェクトを含むmessage変数
    var messages: [Message] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ロードされると必要なデータを取得するデリゲートメソッドを起動
        tableView.dataSource = self
        
        title = K.appName
        navigationItem.hidesBackButton = true
        
        //以下のコードでNibをTableViewに登録
        //そしてMessageCell.xib内でMessageCellのIdentifierを「ReusableCell」と設定することで登録完了
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        
        loadMessages()
    }
    
    func loadMessages() {
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
                
                self.messages = []
                
                if let e = error {
                    print("There was an issue rerieving data from Firestore, \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let messageSender = data[K.FStore.senderField] as? String,
                               let messageBody = data[K.FStore.bodyField] as? String {
                                let newMessage =  Message(sender: messageSender, body: messageBody)
                                self.messages.append(newMessage)
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                            }
                            
                        }
                    }
                }
            }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email{
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) {(error) in
                if let e = error {
                    print("There was an issue saving data to firestore,\(e)")
                } else {
                    print("Successfully saved data.")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                    
                }
            }
        }
    }
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            //signoutを実行し成功したら
            try Auth.auth().signOut()
            // WelcomViewControllerへ（NavigationControllerの一部として取得）
            navigationController?.popToRootViewController(animated: true)
            //signoutに問題があった場合エラーをデバッガーへ
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}



//UITableViewDataSourceプロトコルを適用できるようにするため拡張
//UITableViewDataSourceプロトコルとは、必要なセルの数とtableViewに入れるセルを指示するもの
extension ChatViewController:UITableViewDataSource {
    
    //tableViewに何行のセルを入れるか整数を返すよう要求（この場合countプロパティで配列にあるメッセージの数を動的に返す）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    //tableViewの各行で表示すべきUITableViewCellを要求
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let message = messages[indexPath.row]
        //tableViewにある行の数だけ呼び出されその度に特定のセルを要求
        //MessageCellクラスのすべてのプロパティを取得するため、再利用可能なセルをas!でキャストする
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        as! MessageCell
        //indexPathを使ってメッセージを表示
        cell.label.text = message.body
        
        //This is a message form the currrent user.
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        //This is a message from another sender.
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        
        return cell
    }
}

