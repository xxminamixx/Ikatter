//
//  TweetEntity.swift
//  Ikatter
//
//  Created by 南　京兵 on 2017/04/26.
//  Copyright © 2017年 南　京兵. All rights reserved.
//

import UIKit

class TweetEntity: Comparable {
    var tweet: String?
    var name: String?
    var userID: String?
    var icon: String?
    // ツイートid
    var id: String?
    
    var upperLeftImage: String?
    var upperRightImage: String?
    var buttomLeftImage: String?
    var buttomRightImage: String?
    
    static func == (lhs: TweetEntity, rhs: TweetEntity) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func <(lhs: TweetEntity, rhs: TweetEntity) -> Bool {
        guard let lhsId = lhs.id, let rhsId = rhs.id else {
            // どちらかのidがnilだった場合falseを返す
            return false
        }
        return lhsId < rhsId
    }
    
}
