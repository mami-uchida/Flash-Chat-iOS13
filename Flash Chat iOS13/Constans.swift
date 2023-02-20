//
//  Constans.swift
//  Flash Chat iOS13
//
//  Created by 内田麻美 on 2022/12/20.
//  Copyright © 2022 Angela Yu. All rights reserved.
//
struct K {
    //staticは関連づけられた型プロパティとなりコードを安全に楽に記述する際に向いている
    static let appName = "⚡️FlashChat"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
