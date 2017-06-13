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
    
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetView = UINib(nibName: TweetView.nibName, bundle: nil).instantiate(withOwner: self, options: nil)[0] as? TweetView
        tweetView?.delegate = self
        
        // 各パーツの色設定
        tweetView?.backgroundColor = UIColor.darkGray
        tweetView?.photoButton.backgroundColor = UIColor.lightGray
        tweetView?.tweetButton.backgroundColor = UIColor.lightGray
        
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

extension TweetViewController: TweetViewDelegate {
    func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
