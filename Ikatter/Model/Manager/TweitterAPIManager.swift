//
//  TweitterAPIManager.swift
//  Ikatter
//
//  Created by 南　京兵 on 2017/06/12.
//  Copyright © 2017年 南　京兵. All rights reserved.
//

import Swifter

class TweitterAPIManager {
    
    static var tweetList = [TweetEntity]()
    
    static func tweet(_ text: String) {
        guard let account = AccountStoreManager.shared.account else {
            return
        }
        
        let swifter = Swifter.init(account: account)
        swifter.postTweet(status: text)
    }
    
    static func getTimeLine() {
        guard let account = AccountStoreManager.shared.account else {
            return
        }
        
        let swifter = Swifter(account: account)
        
        // タイムライン取得
        swifter.getHomeTimeline(count: 10, sinceID: sinceId(), maxID: nil, trimUser: nil, contributorDetails: nil, includeEntities: true, success: { json in
            
            TweitterAPIManager.tweetParser(json: json)
            
        }, failure: { error in
            print(error)
        })
    }
    
    /// お気に入り取得
    static func getFavorite() {
        // アカウント情報がなかったら何もしない
        let manager = AccountStoreManager.shared
        guard let account = manager.account else {
            return
        }
        
        let swifter = Swifter(account: account)
        swifter.getRecentlyFavouritedTweets(count: 10, sinceID: nil, maxID: nil, success: { json in
            TweitterAPIManager.tweetParser(json: json)
        })
    }
    
    /// 最新のidを返す
    static func sinceId() -> String? {
        
        if TweitterAPIManager.tweetList.count > 0 {
            // tweetが格納されていた場合
            return TweitterAPIManager.tweetList.last?.id
        } else {
            return nil
        }
        
    }
    
    static func tweetParser(json: JSON) {
        
        if let tweetList = json.array {
            // 各Tweetをパース
            for tweet in tweetList {
                let entity = TweetEntity()
                entity.name = tweet["user"]["name"].string
                entity.icon = tweet["user"]["profile_image_url_https"].string
                entity.tweet = tweet["text"].string
                entity.id = tweet["id_str"].string
                
                // Tweetに含まれる画像urlをパース
                let imageList = tweet["extended_entities"]["media"]
                entity.upperLeftImage = imageList[0]["media_url_https"].string
                entity.upperRightImage = imageList[1]["media_url_https"].string
                entity.buttomLeftImage = imageList[2]["media_url_https"].string
                entity.buttomRightImage = imageList[3]["media_url_https"].string
                
                // TODO: ここの処理重そうなので後で処理回数少なくする方法を考える
                // 同じツイートidがあったら追加しない
                if TweitterAPIManager.tweetList.filter({$0.id == entity.id}).count == 0 {
                    TweitterAPIManager.tweetList.append(entity)
                }
            }
            // 新しいツイート順にソート
            TweitterAPIManager.tweetList.sort(by: {$0 > $1})
        }
        
    }


}
