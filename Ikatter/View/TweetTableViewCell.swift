//
//  TweetTableViewCell.swift
//  Ikatter
//
//  Created by 南　京兵 on 2017/04/18.
//  Copyright © 2017年 南　京兵. All rights reserved.
//

import UIKit
import Cartography

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tweet: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var upperLeftImage: UIImageView!
    @IBOutlet weak var upperRightImage: UIImageView!
    @IBOutlet weak var ButtomLeftImage: UIImageView!
    @IBOutlet weak var ButtomRightImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 現状はImageの場所をとらないようにしておく
        imageHeightAll0()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // 高さ自動計算にしたので一旦コメントアウト
//    // セルの高さを返す
//    func hight() -> CGFloat {
//        // セルを再レイアウト
//        self.contentView.setNeedsLayout()
//        self.contentView.layoutIfNeeded()
//        
//        let nameHeight = 10 + name.frame.size.height + 10
//        let tweetHeight = tweet.frame.size.height + 10
//        let imageHeight = upperLeftImage.frame.size.height + 10 + ButtomLeftImage.frame.size.height + 10
//        // 名前ラベル, ツイートラベル, 画像, 各マージンそれぞれを足したものをセルの高さとして返却
//        return nameHeight + tweetHeight + imageHeight
//    }
    
}

extension TweetTableViewCell {
    
    // 画像の高さを全て0にする
    func imageHeightAll0() {
        constrain(upperLeftImage, upperRightImage, ButtomLeftImage, ButtomRightImage) { view1, view2, view3, view4 in
            view1.height == 0
            view2.height == 0
            view3.height == 0
            view4.height == 0
        }
    }
    
    // 右下の画像の幅を0にする
    func buttonRightWidth0() {
        constrain(ButtomRightImage) { view1 in
            view1.width == 0
        }
    }
    
    // 左下の画像の幅を0にする
    func buttonLeftWidth0() {
        constrain(ButtomLeftImage) { view1 in
            view1.width == 0
        }
    }
    
    // 左下の画像の幅を右上の画像の右端に合わせる
    func buttonLeftWidthAlignRight() {
        constrain(ButtomLeftImage, upperRightImage) { view1, view2 in
            view1.right == view2.right
        }
    }
    
}
