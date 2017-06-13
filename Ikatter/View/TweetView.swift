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
        TweitterAPIManager.tweet(textField.text)
    }
    
    @IBAction func textViewTapped(_ sender: Any) {
        
    }
 
    @IBAction func closeButton(_ sender: Any) {
//        DispatchQueue.main.async {
//            self.textField.becomeFirstResponder()
//        }
        
        delegate?.closeButtonTapped()
    }
}

extension TweetView: UITextViewDelegate {
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if(text == "\n") {
//            textView.resignFirstResponder()
//            return false
//        }
//        return true
//    }
}

