//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by 内田麻美 on 2022/12/21.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    
    //awakeFromNibはviewDidLoadと同じようなもので、アプリが起動したらMessageCellから新しいメッセージを作成する際に呼び出され
    //messageBubbleのlayerを設定する
    override func awakeFromNib() {
        super.awakeFromNib()
        //バブルの半径は高さを5で割った値にする（数値を大きくすれば丸くなる）
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5
        //（Labelの色をWhiteColorに設定）
        //（ユーティリティ内のLinesを0にし行数を無限に設定）
        //（バブルが拡大してもアイコンの位置をTopにするためstackViewのユーティリティ内のAlignmentをTopに設定）
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
