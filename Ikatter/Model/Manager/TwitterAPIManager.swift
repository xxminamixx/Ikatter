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
    
    // ユーザパース時にフォロワーの配列に格納するのかリストメンバの配列に格納するのかの分岐に使う
    enum User {
        case follower
        case listMember
    }
    
    static var tweetList = [TweetEntity]()
    static var listList = [ListEntity]()
    static var followingUserList = [UserEntity]()
    // 現在のリストメンバー
    static var listMemberUserList = [UserEntity]()
    
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
    
//    static func getTimeLine(completion: @escaping () -> Void) {
//        guard let account = AccountStoreManager.shared.account else {
//            return
//        }
//        
//        let swifter = Swifter(account: account)
//        
//        // タイムライン取得
//        swifter.getHomeTimeline(count: 30, sinceID: sinceId(), maxID: nil, trimUser: nil, contributorDetails: nil, includeEntities: true, success: { json in
//            TwitterAPIManager.tweetParser(json: json, completion: completion)
//        }, failure: { error in
//            print(error)
//        })
//    }
    
    
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
    
    
    /// リストメンバ取得
    ///
    /// - Parameters:
    ///   - id: リストID
    ///   - curser: 開始位置
    ///   - completion: 取得後の処理
    static func getListMembers(id: String, curser: String, completion: @escaping () -> Void) {
        guard let swifter = TwitterAPIManager.swifter() else {
            return
        }
        
        swifter.getListMembers(for: ListTag.id(id), cursor: curser, includeEntities: true, skipStatus: true, success: {
           (json, nowCousor, nextCousor) in
            // TODO: パース処理
            if let next = nextCousor {
                TwitterAPIManager.userParser(json: json, handle: .listMember, completion: {
                    if next == "0" {
                        completion()
                    }
                })
            }
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
                
                TwitterAPIManager.getFollowing(id: id, cursor: next, completion: completion)
                TwitterAPIManager.userParser(json: json, handle: .follower, completion: {
                    if next == "0" {
                        // 取得するフォローユーザがいない時クロージャを実行
                        completion()
                    }
                })
            }
            
        }, failure: { error in
            
        })
    }
    
    /// 指定リストの最新ツイートを取得する
    ///
    /// - Parameter id: リストID
    /// - completion: リスト取得後処理
    static func showListNewTweet(id: String, completion: @escaping () -> Void) {
        guard let swifter = TwitterAPIManager.swifter() else {
            return
        }
        
        // 自分のツイートを取得しTweetエンティティに追加
//        swifter.getTweet(forID: AccountStoreManager.shared.getIdentifier(), count: 20, trimUser: true, includeMyRetweet: true, includeEntities: true, success: { json in
//             TwitterAPIManager.tweetParser(json: json, completion: completion)
//        }, failure: { error in
//            print(error)
//        })
        
        swifter.getTimeline(for: AccountStoreManager.shared.getIdentifier(), count: 20, sinceID: nil, maxID: nil, trimUser: false, contributorDetails: true, includeEntities: true, success: { json in
            TwitterAPIManager.tweetParser(json: json, completion: completion)
        }, failure: { error in
            print(error)
        })
        
        // TODO: 自分へのmentionも含めたい
        swifter.getMentionsTimlineTweets(count: 20, sinceID: nil, maxID: nil, trimUser: false, contributorDetails: true, includeEntities: true, success: { json in
            TwitterAPIManager.tweetParser(json: json, completion: completion)
        }, failure: { error in
            print(error)
        })
        
        swifter.listTweets(for: ListTag.id(id), sinceID: sinceId(), maxID: nil, count: 30, includeEntities: true, includeRTs: false, success: { json in
            // リストタイムライン取得時にtweetList初期化
            TwitterAPIManager.tweetParser(json: json, completion: completion)
        }, failure: { error in
            print(error)
        })
        
    }
    
    
    /// 指定リストの過去ツイートを取得する
    ///
    /// - Parameters:
    ///   - id: リストID
    ///   - completion: リスト取得後処理
    static func showListOldTweet(id: String, completion: @escaping () -> Void) {
        guard let swifter = TwitterAPIManager.swifter() else {
            return
        }
        
        swifter.listTweets(for: ListTag.id(id), sinceID: nil, maxID: maxId(), count: 30, includeEntities: true, includeRTs: false, success: { json in
            // リストタイムライン取得時にtweetList初期化
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
//    static func getFavorite(completion: @escaping () -> Void) {
//        // アカウント情報がなかったら何もしない
//        let manager = AccountStoreManager.shared
//        guard let account = manager.account else {
//            return
//        }
//        
//        let swifter = Swifter(account: account)
//        swifter.getRecentlyFavouritedTweets(count: 10, sinceID: nil, maxID: nil, success: { json in
//            TwitterAPIManager.tweetParser(json: json, completion: completion)
//        })
//    }
    
    /// 指定ツイートをお気に入りする
    ///
    /// - Parameter id: ツイートID
    static func postFavorite(id: String, completion: () -> Void) {
        
        // アカウント情報がなかったら何もしない
        let manager = AccountStoreManager.shared
        guard let account = manager.account else {
            return
        }
        
        let swifter = Swifter(account: account)
        swifter.favouriteTweet(forID: id)
        completion()
        
    }
    
    /// 指定ツイートのお気に入りを解除する
    ///
    /// - Parameter id: ツイートID
    static func postUnFavorite(id: String, completion: () -> Void) {
        // アカウント情報がなかったら何もしない
        let manager = AccountStoreManager.shared
        guard let account = manager.account else {
            return
        }
        
        let swifter = Swifter(account: account)
        swifter.unfavouriteTweet(forID: id)
        completion()
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
    /// ツイートEntityがソートされて最新ツイート順に並んでる前提
    static func sinceId() -> String? {
        
        if TwitterAPIManager.tweetList.count > 0 {
            // tweetが格納されていた場合
            return TwitterAPIManager.tweetList.first?.id
        } else {
            return nil
        }
        
    }
    
    /// 最古のidを返す
    /// ツイートEntityがソートされて最新ツイート順に並んでる前提
    static func maxId() -> String? {
        
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
                
                entity.isFavorite = tweet["favorited"].bool!
                entity.isRetweet = tweet["retweeted"].bool!
                
                entity.favoriteCount = String(describing: tweet["favorite_count"])
                entity.retweetCount = String(describing: tweet["retweet_count"])
                
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
    
    // フォローユーザ取得時のユーザパースに使う
    static func userParser(json: JSON, handle: User, completion: () -> Void) {
        
        if let users = json.array {
            for user in users {
                let entity = UserEntity()
                entity.id = user["id_str"].string
                entity.name = user["name"].string
                entity.text = user["description"].string
                entity.icon = user["profile_image_url_https"].string
                entity.header = user["profile_background_image_url_https"].string

                switch handle {
                case .follower:
                    if TwitterAPIManager.listMemberUserList.filter({$0.id == entity.id}).count > 0 {
                        // リストメンバに存在する場合
                        entity.isSelected = true
                    }
                    TwitterAPIManager.followingUserList.append(entity)
                case .listMember:
                    TwitterAPIManager.listMemberUserList.append(entity)
                }
                
                if user == users.last {
                    // パースが最後のユーザのとき
                    completion()
                }
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
