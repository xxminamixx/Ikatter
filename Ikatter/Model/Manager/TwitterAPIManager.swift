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
    static var listList = [ListEntity]()
    static var followingUserList = [UserEntity]()
    
    /// swifterインスタンスを返す
    ///
    /// - Returns: 選択しているswifterインスタンス
    static func swifter() -> Swifter? {
        guard let account = AccountStoreManager.shared.account else {
            return nil
        }
        
        return Swifter(account: account)
    }
    
    static func tweet(_ text: String, completion: () -> Void) {
        guard let account = AccountStoreManager.shared.account else {
            return
        }
        
        let swifter = Swifter.init(account: account)
        swifter.postTweet(status: text)
        completion()
    }
    
    static func getTimeLine(completion: @escaping () -> Void) {
        guard let account = AccountStoreManager.shared.account else {
            return
        }
        
        let swifter = Swifter(account: account)
        
        // タイムライン取得
        swifter.getHomeTimeline(count: 30, sinceID: sinceId(), maxID: nil, trimUser: nil, contributorDetails: nil, includeEntities: true, success: { json in
            TwitterAPIManager.tweetParser(json: json, completion: completion)
        }, failure: { error in
            print(error)
        })
    }
    
    
    /// リスト取得
    ///
    /// - Parameter completion: リスト取得後の処理
    static func getlist(completion: @escaping () -> Void) {
        guard let account = AccountStoreManager.shared.account else {
            return
        }
        
        let swifter = Swifter(account: account)
        
        swifter.getSubscribedLists(reverse: true, success: { json in
            TwitterAPIManager.listParser(json: json, completion: completion)
        }, failure: { error in
            print(error)
        })
    }
    
    
    /// フォローしているユーザを取得
    ///
    /// - Parameters:
    ///   - id: ユーザID
    ///   - cursor: ページングする際の取得開始位置
    ///   - completion: フォローユーザ取得後の処理
    static func getFollowing(id: String, cursor: String?, completion: @escaping () -> Void) {
        guard let swifter = TwitterAPIManager.swifter() else {
            return
        }

        swifter.getUserFollowing(for: UserTag.id(id), cursor: cursor, count: 100, skipStatus: true, includeUserEntities: true, success: { (json, nowCousor, nextCousor) in
            
            if let next = nextCousor {
                // 次の取得開始位置を更新
                if next != "0" {
                    TwitterAPIManager.getFollowing(id: id, cursor: next, completion: completion)
                    TwitterAPIManager.UserParser(json: json)
                } else {
                    // 取得するフォローユーザがいない時クロージャを実行
                    completion()
                }
            }
            
        }, failure: { error in
            
        })
    }
    
    /// 指定リストをTweetListに格納する
    ///
    /// - Parameter id: リストID
    static func showList(id: String, completion: @escaping () -> Void) {
        guard let swifter = TwitterAPIManager.swifter() else {
            return
        }
        
        swifter.listTweets(for: ListTag.id(id), sinceID: sinceId(), maxID: nil, count: 30, includeEntities: true, includeRTs: true, success: { json in
            // リストタイムライン取得時にtweetList初期化
            // 他のAPIで取得したツイートと混同させないため
            TwitterAPIManager.tweetList = [TweetEntity]()
            TwitterAPIManager.tweetParser(json: json, completion: completion)
        }, failure: { error in
            print(error)
        })
        
    }
    
    
    /// リストを作成する
    ///
    /// - Parameters:
    ///   - name: リスト名
    ///   - description: リストの説明文
    static func createList(name: String, description: String, isPublic: Bool, completion: @escaping () -> Void){
        guard let swifter = TwitterAPIManager.swifter() else {
            return
        }
        
        swifter.createList(named: name, description: description, success: { json in
            completion()
        }, failure: { error in
            
        })
        
        swifter.createList(named: name, asPublicList: isPublic, description: description, success: { json in
            print("jsonデータ -> \(json)")
        }, failure: { error in
        })
    }
    
    
    /// リスト削除
    ///
    /// - Parameters:
    ///   - id: 削除リストのID
    ///   - completion: リスト削除後の処理
    static func deleteList(id: String, completion: @escaping () -> Void) {
        guard let swifter = TwitterAPIManager.swifter() else {
            return
        }

        swifter.deleteList(for: ListTag.id(id), success: { json in
            completion()
        }, failure: { error in
        
        })
    }
    
    /// リストにユーザを追加する
    ///
    /// - Parameters:
    ///   - userID: ユーザID
    ///   - listID: 追加先のリストID
    ///   - completion: リスト追加後の処理
    static func addListMember(userID: String, listID: String, completion: @escaping () -> Void) {
        guard let swifter = TwitterAPIManager.swifter() else {
            return
        }
        
        swifter.addListMember(UserTag.id(userID), for: ListTag.id(listID), success: { json in
            
        }, failure: { error in
            
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
    
    
    /// 指定ツイートをリツイートする
    ///
    /// - Parameter id: ツイートID
    static func postRetweet(id: String) {
        let manager = AccountStoreManager.shared
        guard let account = manager.account else {
            return
        }
        
        let swifter = Swifter(account: account)
        swifter.retweetTweet(forID: id)
    }
    
    
    /// 指定ツイートのリツイートを解除する
    ///
    /// - Parameter id: ツイートID
    static func postUnRetweet(id: String) {
        let manager = AccountStoreManager.shared
        guard let account = manager.account else {
            return
        }
        
        let swifter = Swifter(account: account)
        swifter.UnretweetTweet(forID: id)
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
                entity.userID = tweet["user"]["screen_name"].string
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
    
    static func listParser(json: JSON, completion: () -> Void) {
        
        if let lists = json.array {
            for list in lists {
                let entity = ListEntity()
                entity.id = list["id_str"].string
                entity.name = list["name"].string
                entity.description = list["description"].string
                // 同じリストIDがあったら追加しない
                if TwitterAPIManager.listList.filter({$0.id == entity.id}).count == 0 {
                    TwitterAPIManager.listList.append(entity)
                }
            }
            completion()
        }

    }
    
    static func UserParser(json: JSON) {
        
        if let users = json.array {
            for user in users {
                let entity = UserEntity()
                entity.id = user["id_str"].string
                entity.name = user["name"].string
                entity.text = user["description"].string
                entity.icon = user["profile_image_url_https"].string
                entity.header = user["profile_background_image_url_https"].string
                
                TwitterAPIManager.followingUserList.append(entity)
            }
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
