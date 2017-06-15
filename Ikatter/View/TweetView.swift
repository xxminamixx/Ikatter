//
//  TweetView.swift
//  Ikatter
//
//  Created by 南　京兵 on 2017/06/12.
//  Copyright © 2017年 南　京兵. All rights reserved.
//

import UIKit

protocol TweetViewDelegate {
    func closeButtonTapped()
}

class TweetView: UIView {

    static let nibName = "TweetView"
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var textField: UITextView!
    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var tweetButton: UIButton!
    
    var delegate: TweetViewDelegate?
    
    override func awakeFromNib() {
        textField.changeCaret(-8)
        textField.becomeFirstResponder()
        delegate = nil
    }
    
    @IBAction func photoButton(_ sender: Any) {
    }
    
    @IBAction func tweetButton(_ sender: Any) {
        TwitterAPIManager.tweet(textField.text)
    }
    
    @IBAction func textViewTapped(_ sender: Any) {
        
    }
 
    @IBAction func closeButton(_ sender: Any) {
        delegate?.closeButtonTapped()
    }
}

extension TweetView: UITextViewDelegate {}

