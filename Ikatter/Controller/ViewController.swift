//
//  ViewController.swift
//  Ikatter
//
//  Created by 南　京兵 on 2017/04/18.
//  Copyright © 2017年 南　京兵. All rights reserved.
//

import UIKit
import Accounts
//import Social
import Swifter
import AlamofireImage


class ViewController: UIViewController {
    
    @IBOutlet weak var tweetTableView: UITableView!
    
    var searchBar: UISearchBar!
    var accountStore = ACAccountStore()
    var account: ACAccount?
    var tweetList = [TweetEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectTwitterAccount()
        
        // サーチバーを表示
        setupSearchBar()
        
        // ステージと武器一覧のTableViewの初期設定
        tweetTableView.dataSource = self
        tweetTableView.delegate = self
        let nib = UINib.init(nibName: "TweetTableViewCell", bundle: nil)
        tweetTableView.register(nib, forCellReuseIdentifier: "TweetTableViewCell")
        
        // TableViewの高さ自動計算
        tweetTableView.estimatedRowHeight = 240
        tweetTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if account != nil {
            let swifter = Swifter(account: account!)
            
            // タイムライン取得
            swifter.getHomeTimeline(count: 10, success: { json in
                
                // jsonを配列に変換
                if let tweetList = json.array {
                    // 各Tweetをパース
                    for tweet in tweetList {
                        let entity = TweetEntity()
                        entity.name = tweet["user"]["name"].string
                        entity.icon = tweet["user"]["profile_image_url_https"].string
                        entity.tweet = tweet["text"].string
                        
                        // Tweetに含まれる画像urlをパース
                        let imageList = tweet["extended_entities"]["media"]["media_url_https"]
                        entity.upperLeftImage = imageList[0].string
                        entity.upperRightImage = imageList[1].string
                        entity.buttomLeftImage = imageList[2].string
                        entity.buttomRightImage = imageList[3].string
                        
                        self.tweetList.append(entity)
                    }
                    self.tweetTableView.reloadData()
                }
                
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // 端末に登録されているTwitterアカウント取得
    private func selectTwitterAccount() {
        
        let accountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccounts(with: accountType, options: nil, completion: { (granted, error) -> Void in
           
            // エラー発生
            guard error == nil else {
                return
            }
            
            // アカウントの利用許可がされていない
            guard granted else {
                return
            }
            
            let defaults = UserDefaults.standard
            if let accountIdentifire = defaults.object(forKey: "account") {
                self.account = self.accountStore.account(withIdentifier: accountIdentifire as! String)
            } else {
                if let accounts = self.accountStore.accounts {
                    // 複数のアカウントから選択させる
                    self.chooseAccount(accounts: accounts as! [ACAccount])
                }
            }
            
        })
    }
    
    
    /// 複数のTwitterアカウントから選択したアカウントを自身のプロパティにセットする
    ///
    /// - Parameter accounts: 端末に登録されているTiwtterアカウント配列
    private func chooseAccount(accounts: [ACAccount]){
        
        let alert = UIAlertController(title: "Twitter", message: "Choose an account", preferredStyle: .actionSheet)
        
        for account in accounts {
            alert.addAction(UIAlertAction(title: account.username,
                                          style: .default,
                                          handler: { (action) -> Void in
                                            
                                            // 自身のプロパティにセット
                                            self.account = account
                                            
                                            // アカウントIDをNSURLDefaultsで永続化
                                            let userDefaults = UserDefaults.standard
                                            userDefaults.set(account.identifier, forKey: "account")
                                            
//                                            self.loadViewIfNeeded()
                                        }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    
    
//    private func chooseAccount(accounts: [ACAccount]) {
//        
//        let alert = UIAlertController(title: "Twitter", message: "Choose an account", preferredStyle: .actionSheet)
//        
//        for account in accounts {
//            alert.addAction(UIAlertAction(title: account.username,
//                                          style: .default,
//                                          handler: { [weak self] (action) -> Void in
//                                            if let unwrapSelf = self {
//                                                // 選択したアカウントをプロパティで保持
//                                                unwrapSelf.account = account
//                                                
//                                                // Swifterインスタンス
//                                                let swifter = Swifter(account: account)
//                                                
//                                                // タイムライン取得
//                                                swifter.getHomeTimeline(count: 10, success: { json in
//                                                    print(json)
//                                                    
//                                                    // jsonを配列に変換
//                                                    if let tweetList = json.array {
//                                                        // 各Tweetをパース
//                                                        for tweet in tweetList {
//                                                            let entity = TweetEntity()
//                                                            entity.name = tweet["user"]["name"].string
//                                                            entity.icon = tweet["user"]["profile_image_url_https"].string
//                                                            entity.tweet = tweet["text"].string
//                                                            
//                                                            self?.tweetList.append(entity)
//                                                        }
//                                                        self?.tweetTableView.reloadData()
//                                                    }
//                                                }, failure: { error in
//                                                    print(error)
//                                                })
//                                                
//                                                // お気に入り取得処理
////                                                swifter.getRecentlyFavouritedTweets(count: 10, sinceID: nil, maxID: nil, success: { json in
////                                                    print(json)
////                                                }, failure: { error in
////                                                    print(error)
////                                                })
//                                                
////                                                // 検索
////                                                swifter.searchTweet(using: "アマゾン", geocode: nil, lang: "ja", locale: "ja", resultType: nil, count: 50, until: nil, sinceID: nil, maxID: nil, includeEntities: true, callback: nil, success: { json in
////                                                    
////                                                }, failure: { error in
////                                                    print(error)
////                                                })
//                                                
//
//                                            }
//            }))
//        }
//        
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
    
    // MARK: サーチバーをナビゲーションバーに表示する
    private func setupSearchBar() {
        if let navigationBarFrame = navigationController?.navigationBar.bounds {
            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
            searchBar.delegate = self
            searchBar.placeholder = "Search"
            searchBar.showsCancelButton = true
            searchBar.autocapitalizationType = UITextAutocapitalizationType.none
            searchBar.keyboardType = UIKeyboardType.default
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = searchBar.frame
            self.searchBar = searchBar
            searchBar.becomeFirstResponder()
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath) as! TweetTableViewCell
        
        // MARK: セルのセットアップ
        
        // TweetEntityの並びでセルにデータをセット
        if tweetList.count > 0 {
            let tweet = tweetList[indexPath.row]
            cell.name.text = tweet.name
            cell.tweet.text = tweet.tweet
            cell.tweet.sizeToFit()
            
            // アイコン画像セット
            if let url = tweet.icon {
                cell.icon.af_setImage(withURL: URL(string: url)!)
            }
            
            // 右下の画像セット
            if let url = tweet.buttomRightImage {
                cell.ButtomRightImage.af_setImage(withURL: URL(string: url)!)
            } else {
                // 画像がなかった場合
                cell.buttonRightWidth0()
            }
            
            // 左下の画像セット
            if let url = tweet.buttomLeftImage {
                cell.ButtomLeftImage.af_setImage(withURL: URL(string: url)!)
            } else {
                cell.buttonLeftWidth0()
            }
            
            // 右上の画像セット
            if let url = tweet.upperRightImage {
                cell.upperRightImage.af_setImage(withURL: URL(string: url)!)
            }
            
            // 左上の画像セット
            if let url = tweet.upperLeftImage {
                cell.upperLeftImage.af_setImage(withURL: URL(string: url)!)
            }
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {}

extension ViewController: UISearchBarDelegate {
    // TODO: サーチバーに入力した文字でTweetを検索しテーブルビューに表示
}
