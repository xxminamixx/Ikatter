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
    
    var accountStore = ACAccountStore()
    var account: ACAccount?

    override func viewDidLoad() {
        super.viewDidLoad()
        selectTwitterAccount()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

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
}

