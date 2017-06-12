//
//  TweitterAPIManager.swift
//  Ikatter
//
//  Created by 南　京兵 on 2017/06/12.
//  Copyright © 2017年 南　京兵. All rights reserved.
//

import Swifter

class TweitterAPIManager {
    
    static func tweet(_ text: String) {
        guard let account = AccountStoreManager.shared.account else {
            return
        }
        
        let swifter = Swifter.init(account: account)
        swifter.postTweet(status: text)
    }

}
