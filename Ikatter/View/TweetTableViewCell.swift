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
    // ボタンタップ時のメソッド
    func pressdFavorite(cell: TweetTableViewCell)
    func pressdUnFavorite(cell: TweetTableViewCell)
    func pressdReply(cell: TweetTableViewCell)
    func pressdRetweet(cell: TweetTableViewCell)
    func pressdUnRetweet(cell: TweetTableViewCell)
    
    // 画像タップ時のメソッド
    func pressdUpperLeftImage(url: String)
}

class TweetTableViewCell: UITableViewCell {
    
    enum ImageTouchTag: Int {
        case upperLeft
        case upperRight
        case buttomLeft
        case buttomRight
    }

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tweet: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var upperLeftImage: UIImageView!
    @IBOutlet weak var upperRightImage: UIImageView!
    @IBOutlet weak var ButtomLeftImage: UIImageView!
    @IBOutlet weak var ButtomRightImage: UIImageView!
    
    /// お気に入りボタン
    @IBOutlet weak var favoriteButton: DOFavoriteButton!
    /// リプライボタン
    @IBOutlet weak var replyButton: DOFavoriteButton!
    /// リツイートボタン
    @IBOutlet weak var retweetButton: DOFavoriteButton!
    
    var upperLeftImageURL: String?
    var upperRightImageURL: String?
    var buttomLeftImageURL: String?
    var buttomRightImageURL: String?
    var delegate: TweetTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // お気に入りボタンの設定
        favoriteButton.imageColorOff = UIColor.gray
        favoriteButton.imageColorOn = ConstColor.pink
        favoriteButton.circleColor = ConstColor.pink
        favoriteButton.lineColor = ConstColor.pink
        favoriteButton.addTarget(self, action: #selector(favorite(sender:)), for: .touchUpInside)
        
        // リプライボタンの設定
        replyButton.imageColorOff = UIColor.gray
        replyButton.imageColorOn = ConstColor.skyBlue
        replyButton.circleColor = ConstColor.skyBlue
        replyButton.lineColor = ConstColor.skyBlue
        replyButton.addTarget(self, action: #selector(reply(sender:)), for: .touchUpInside)
        
        // リツイートボタンの設定
        retweetButton.imageColorOff = UIColor.gray
        retweetButton.imageColorOn = ConstColor.green
        retweetButton.circleColor = ConstColor.green
        retweetButton.lineColor = ConstColor.green
        retweetButton.addTarget(self, action: #selector(retweet(sender:)), for: .touchUpInside)
        
        // 左上の画像タップ時のGestureを登録
        let upperLeftImageTappGesture = UITapGestureRecognizer(target: self, action: #selector(upperLeftImageTapped))
        
        upperLeftImage.addGestureRecognizer(upperLeftImageTappGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // 左上の画像をタップした時に呼ばれる
    func upperLeftImageTapped() {
        guard let url = upperLeftImageURL else {
            return
        }
        
        delegate?.pressdUpperLeftImage(url: url)
    }
    
    func setup(entity: TweetEntity) {
        name.text = entity.name
        tweet.text = entity.tweet
        tweet.sizeToFit()
        
        // アイコン画像セット
        if let url = entity.icon {
            self.icon.af_setImage(withURL: URL(string: url)!)
        }
        
        // 右下の画像セット
        if let url = entity.buttomRightImage {
            buttomRightImageURL = url
            self.ButtomRightImage.af_setImage(withURL: URL(string: url)!)
        } else {
            self.buttonLeftWidthAlignRight()
            self.buttonRightWidth0()
        }
        
        // 左下の画像セット
        if let url = entity.buttomLeftImage {
            buttomLeftImageURL = url
            self.ButtomLeftImage.af_setImage(withURL: URL(string: url)!)
        } else {
            self.buttonLeftWidth0()
            self.buttomImageHeight0()
        }
        
        // 右上の画像セット
        if let url = entity.upperRightImage {
            upperRightImageURL = url
            self.upperRightImage.af_setImage(withURL: URL(string: url)!)
        } else {
            self.upperLeftWidthAlignRight()
            self.upperRightWidth0()
        }
        
        // 左上の画像セット
        if let url = entity.upperLeftImage {
            upperLeftImageURL = url
            self.upperLeftImage.af_setImage(withURL: URL(string: url)!)
        } else {
            self.upperLeftWidth0()
            self.upperImageHeight0()
        }

        self.setNeedsLayout()
        self.layoutIfNeeded()
        
    }
    
    /// お気に入りボタンが押された時の処理
    func favorite(sender: DOFavoriteButton) {
        
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
    
    /// リプライボタンが押された時の処理
    func reply(sender: DOFavoriteButton) {
        
        if sender.isSelected {
            sender.deselect()
        } else {
            delegate?.pressdReply(cell: self)
            sender.select()
        }
        
    }
    
    
    /// リツイートボタンが押された時の処理
    func retweet(sender: DOFavoriteButton) {
        
        if sender.isSelected {
            delegate?.pressdUnRetweet(cell: self)
            sender.deselect()
        } else {
            delegate?.pressdRetweet(cell: self)
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
