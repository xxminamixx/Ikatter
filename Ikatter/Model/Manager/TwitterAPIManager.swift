//
//  TweitterAPIManager.swift
//  Ikatter
//
//  Created by 南　京兵 on 2017/06/12.
//  Copyright © 2017年 南　京兵. All rights reserved.
//

import Swifter
import Accounts

class TwitterAPIManager {
    
    static var tweetList = [TweetEntity]()
    
    static func tweet(_ text: String) {
        guard let account = AccountStoreManager.shared.account else {
            return
        }
        
        let swifter = Swifter.init(account: account)
        swifter.postTweet(status: text)
    }
    
    static func getTimeLine(completion: @escaping () -> Void) {
        guard let account = AccountStoreManager.shared.account else {
            return
        }
        
        let swifter = Swifter(account: account)
        
        // タイムライン取得
        swifter.getHomeTimeline(count: 10, sinceID: sinceId(), maxID: nil, trimUser: nil, contributorDetails: nil, includeEntities: true, success: { json in
            
            TwitterAPIManager.tweetParser(json: json, completion: completion)
            
        }, failure: { error in
            print(error)
        })
    }
    
    /// お気に入り取得
    static func getFavorite(completion: @escaping () -> Void) {
        // アカウント情報がなかったら何もしない
        let manager = AccountStoreManager.shared
        guard let account = manager.account else {
            return
        }
        
        let swifter = Swifter(account: account)
        swifter.getRecentlyFavouritedTweets(count: 10, sinceID: nil, maxID: nil, success: { json in
            TwitterAPIManager.tweetParser(json: json, completion: completion)
        })
    }
    
    /// 指定ツイートをお気に入りする
    ///
    /// - Parameter id: ツイートID
    static func postFavorite(id: String) {
        
        // アカウント情報がなかったら何もしない
        let manager = AccountStoreManager.shared
        guard let account = manager.account else {
            return
        }
        
        let swifter = Swifter(account: account)
        swifter.favouriteTweet(forID: id)
        
    }
    
    /// 指定ツイートのお気に入りを解除する
    ///
    /// - Parameter id: ツイートID
    static func postUnFavorite(id: String) {
        // アカウント情報がなかったら何もしない
        let manager = AccountStoreManager.shared
        guard let account = manager.account else {
            return
        }
        
        let swifter = Swifter(account: account)
        swifter.unfavouriteTweet(forID: id)
    }

    
    /// 最新のidを返す
    static func sinceId() -> String? {
        
        if TwitterAPIManager.tweetList.count > 0 {
            // tweetが格納されていた場合
            return TwitterAPIManager.tweetList.last?.id
        } else {
            return nil
        }
        
    }
    
    static func tweetParser(json: JSON, completion: () -> Void) {
        
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
                if TwitterAPIManager.tweetList.filter({$0.id == entity.id}).count == 0 {
                    TwitterAPIManager.tweetList.append(entity)
                }
            }
            // 新しいツイート順にソート
            TwitterAPIManager.tweetList.sort(by: {$0 > $1})
            completion()
        }
        
    }

    /// ACAccountからiconのURL文字列を取得し、クロージャでそのURLを用いて行いたい処理を渡す
    ///
    /// - Parameters:
    ///   - account: iconURL文字列を取得するアカウント
    ///   - completion: iconURL文字列を用いて行いたい処理
    static func getUserIcon(account: ACAccount, completion: @escaping (_ icon: String) -> Void) {
        
        let swifter = Swifter(account: account)
        var icon: String?
        
        swifter.showUser(for: UserTag.screenName(account.username), success: { json in
            icon = json["profile_image_url_https"].string
            
        }, failure: { error in
            icon = nil
        })
        
        WaitContinuation.wait({icon == nil}, compleation: {
            guard let safeIcon = icon else {
                return
            }
           completion(safeIcon)
        })
    }
    
}
