//
//  TweetTableViewCell.swift
//  Ikatter
//
//  Created by 南　京兵 on 2017/04/18.
//  Copyright © 2017年 南　京兵. All rights reserved.
//

import UIKit
import Cartography
import DOFavoriteButton

protocol TweetTableViewCellDelegate {
    func pressdFavorite(cell: TweetTableViewCell)
    func pressdUnFavorite(cell: TweetTableViewCell)
}

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tweet: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var upperLeftImage: UIImageView!
    @IBOutlet weak var upperRightImage: UIImageView!
    @IBOutlet weak var ButtomLeftImage: UIImageView!
    @IBOutlet weak var ButtomRightImage: UIImageView!
    
    /// お気に入りボタン
    @IBOutlet weak var favoriteButton: DOFavoriteButton!
    
    var delegate: TweetTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        favoriteButton.addTarget(self, action: Selector.init("tapped"), for: .touchUpInside)
        favoriteButton.imageColorOff = UIColor.gray
        favoriteButton.imageColorOn = ConstColor.pink
        favoriteButton.circleColor = ConstColor.pink
        favoriteButton.lineColor = ConstColor.pink
        favoriteButton.addTarget(self, action: #selector(tapped(sender:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    /// お気に入りボタンが押された時の処理
    func tapped(sender: DOFavoriteButton) {
        
        if sender.isSelected {
            // お気に入りを解除する
            
            delegate?.pressdUnFavorite(cell: self)
            sender.deselect()
        } else {
            // お気に入りする
            
            delegate?.pressdFavorite(cell: self)
            sender.select()
        }
        
    }
    
}

extension TweetTableViewCell {
    
    /* 幅0系 */
    
    // 右下の画像の幅を0にする
    func buttonRightWidth0() {
        constrain(ButtomRightImage) { view in
            view.width == 0
        }
    }
    
    // 左下の画像の幅を0にする
    func buttonLeftWidth0() {
        constrain(ButtomLeftImage) { view in
            view.width == 0
        }
    }
    
    // 右上の画像の幅を0にする
    func upperRightWidth0() {
        constrain(upperRightImage) { view in
            view.width == 0
        }
    }
    
    // 左上の画像の幅を0にする
    func upperLeftWidth0() {
        constrain(upperLeftImage) { view in
            view.width == 0
        }
    }
    
    /* 高さ0系 */
    
    // 画像の高さを全て0にする
    func imageHeightAll0() {
        constrain(upperLeftImage, upperRightImage, ButtomLeftImage, ButtomRightImage) { view1, view2, view3, view4 in
            view1.height == 0
            view2.height == 0
            view3.height == 0
            view4.height == 0
        }
    }
    
    // 下段の画像2枚の高さを0にする
    func buttomImageHeight0() {
        constrain(ButtomLeftImage, ButtomRightImage) { view1, view2 in
            view1.height == 0
            view2.height == 0
        }
    }
    
    // 上段の画像2枚の高さを0にする
    func upperImageHeight0() {
        constrain(upperLeftImage, upperRightImage) { view1, view2 in
            view1.height == 0
            view2.height == 0
        }
    }
    
    /* 整列系 */
    
    // 左下の画像の幅を右上の画像の右端に合わせる
    func buttonLeftWidthAlignRight() {
        constrain(ButtomLeftImage, upperRightImage) { view1, view2 in
            view1.right == view2.right
        }
    }
    
    // 左上の画像の幅をtweetラベルの右端に合わせる
    func upperLeftWidthAlignRight() {
        constrain(upperLeftImage, tweet) { view1, view2 in
            view1.right == view2.right
        }
    }
    
}
