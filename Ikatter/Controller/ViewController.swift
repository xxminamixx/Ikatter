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


class ViewController: UIViewController {
    
    @IBOutlet weak var tweetTableView: UITableView!
    
    var searchBar: UISearchBar!
    var accountStore = ACAccountStore()
    var account: ACAccount?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // プロパティにツイッターアカウントセット
        selectTwitterAccount()
        
        // サーチバーを表示
        setupSearchBar()
        
        // ステージと武器一覧のTableViewの初期設定
        tweetTableView.dataSource = self
        tweetTableView.delegate = self
        let nib = UINib.init(nibName: "TweetTableViewCell", bundle: nil)
        tweetTableView.register(nib, forCellReuseIdentifier: "TweetTableViewCell")
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
            
            if let accounts = self.accountStore.accounts {
                self.chooseAccount(accounts: accounts as! [ACAccount])
                if let account = self.account {
                    // Swifterでタイムライン取得
                    let swifter = Swifter(account: account)
                    swifter.getHomeTimeline(count: 10, success: { json in
                        print(json)
                    }, failure: { error in
                        print(error)
                    })
                }
            }
            
        })
    }
    
    
    /// 複数のTwitterアカウントから選択したアカウントを自身のプロパティにセットする
    ///
    /// - Parameter accounts: 端末に登録されているTiwtterアカウント配列
    private func chooseAccount(accounts: [ACAccount]) {
        
        let alert = UIAlertController(title: "Twitter", message: "Choose an account", preferredStyle: .actionSheet)
        
        for account in accounts {
            alert.addAction(UIAlertAction(title: account.username,
                                          style: .default,
                                          handler: { [weak self] (action) -> Void in
                                            if let unwrapSelf = self {
                                                // 選択したアカウントをプロパティで保持
                                                unwrapSelf.account = account
                                                
                                                // Swifterインスタンス
                                                let swifter = Swifter(account: account)
                                                
                                                // タイムライン取得
//                                                swifter.getHomeTimeline(count: 10, success: { json in
//                                                    print(json)
//                                                }, failure: { error in
//                                                    print(error)
//                                                })
                                                
                                                // お気に入り取得処理
                                                swifter.getRecentlyFavouritedTweets(count: 10, sinceID: nil, maxID: nil, success: { json in
                                                    print(json)
                                                }, failure: { error in
                                                    print(error)
                                                })
                                                
                                                // 検索
//                                                swifter.searchTweet(using: "swift", geocode: nil, lang: nil, locale: nil, resultType: nil, count: 10, until: nil, sinceID: nil, maxID: nil, includeEntities: nil, callback: nil, success: { json in
//                                                    print(json)
//                                                }, failure: { error in
//                                                    print(error)
//                                                })
                                                

                                            }
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
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
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath) as! TweetTableViewCell
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}

extension ViewController: UISearchBarDelegate {
    // TODO: サーチバーに入力した文字でTweetを検索しテーブルビューに表示
}
