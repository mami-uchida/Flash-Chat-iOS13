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
                //ifでエラーチェックしたら、後続に進むことはないのでreturnして終了
                if let e = error {
                    print("There was an issue rerieving data from Firestore, \(e)")
                    return
                }
                //可能な限り、if letでブロックを囲むより、guardで早期リターンしてブロックの大きさを小さく保つ
                //（深すぎるネストはコードチェックツールでチェックが入り、修正が必要になる場合があるため）
                guard let snapshotDocuments = querySnapshot?.documents else { return }
                for doc in snapshotDocuments {
                    let data = doc.data()
                    guard let messageSender = data[K.FStore.senderField] as? String,
                          let messageBody = data[K.FStore.bodyField] as? String else { return }
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
        //MessageCellクラスのすべてのプロパティを取得するためdequeueReusableCellをはguard letでアンラップしダウンキャスト
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as? MessageCell else { return UITableViewCell()}
        //indexPathを使ってメッセージを表示
        cell.label.text = message.body
        
        //trueかfalseで設定が変わる時は三項演算子
        let isCurrentUser = message.sender == Auth.auth().currentUser?.email
        cell.leftImageView.isHidden = isCurrentUser
        cell.rightImageView.isHidden = !isCurrentUser
        cell.messageBubble.backgroundColor = isCurrentUser ? UIColor(named: K.BrandColors.lightPurple) : UIColor(named: K.BrandColors.purple)
        cell.label.textColor = isCurrentUser ? UIColor(named: K.BrandColors.purple) : UIColor(named: K.BrandColors.lightPurple)
        
        return cell
    }
}

