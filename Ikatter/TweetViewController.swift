//
//  TweetViewController.swift
//  Ikatter
//
//  Created by 南　京兵 on 2017/06/12.
//  Copyright © 2017年 南　京兵. All rights reserved.
//

import UIKit
import Cartography

class TweetViewController: UIViewController {
    
    static let nibName = "TweetViewController"
    var tweetView: TweetView?
    var userID: String?
    
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetView = UINib(nibName: TweetView.nibName, bundle: nil).instantiate(withOwner: self, options: nil)[0] as? TweetView
        tweetView?.delegate = self
        
        // 各パーツの色設定
        tweetView?.backgroundColor = UIColor.darkGray
        tweetView?.photoButton.backgroundColor = ConstColor.iconGreen
        tweetView?.photoButton.tintColor = UIColor.white
        tweetView?.tweetButton.backgroundColor = ConstColor.iconGreen
        tweetView?.tweetButton.tintColor = UIColor.white
        
        // ユーザIDをTextViewにセット
        if userID != nil {
            tweetView?.textField.text = "@" + userID! + " "
            tweetView?.tweetButton.setTitle("リプライ", for: .application)
        }
        
        // アイコンをセット
        if let account = AccountStoreManager.shared.account {
            TwitterAPIManager.getUserIcon(account: account, completion: { (icon: String?) in
                guard let safeIcon = icon else {
                    return
                }
                self.tweetView?.icon.af_setImage(withURL: URL(string: safeIcon)!)
            })
        }
        
        self.contentView.addSubview(tweetView!)
        
        constrain(tweetView!) { view1 in
            view1.height == 300
            view1.width == UIScreen.main.bounds.width
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

}

// MARK: TweetViewDelegate
extension TweetViewController: TweetViewDelegate {
    
    func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tweetButtonTapped(text: String) {
        TwitterAPIManager.tweet(text, completion: {
            self.dismiss(animated: true, completion: nil)
        })
    }
    
}
