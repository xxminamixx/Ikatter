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

    @IBOutlet weak var overView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tweetView = UINib(nibName: TweetView.nibName, bundle: nil).instantiate(withOwner: self, options: nil)[0] as! TweetView
        contentView.addSubview(tweetView)

    }
    
    // Viewがタッチされた時呼び出される
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch: UITouch in touches {
            let tag = touch.view!.tag
            if tag == 1 {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

}
