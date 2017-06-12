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
        constrain(tweetView!) { view in
            view.height == 300
            view.width == UIScreen.main.bounds.width
        }
        
        self.contentView.addSubview(tweetView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

}
