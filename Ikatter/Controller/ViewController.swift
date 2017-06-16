//
//  ViewController.swift
//  Ikatter
//
//  Created by 南　京兵 on 2017/04/18.
//  Copyright © 2017年 南　京兵. All rights reserved.
//

import UIKit
import AlamofireImage
import DGElasticPullToRefresh
import Accounts
import Swifter


class ViewController: UIViewController {
    
    @IBOutlet weak var tweetTableView: UITableView!
    
    var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectTwitterAccount()
        
//        // サーチバーを表示
//        setupSearchBar()
        // ツイートボタンをNavigationBarの右に追加
        let rightTweetButton = UIButton()
        rightTweetButton.setImage(UIImage(named: "pencil.png"), for: .normal)
        rightTweetButton.sizeToFit()
        rightTweetButton.addTarget(self, action: #selector(tweet), for: UIControlEvents.touchUpInside)
        let rightTweetButtonItem = UIBarButtonItem(customView: rightTweetButton)
        self.navigationItem.setRightBarButtonItems([rightTweetButtonItem], animated: true)
        
        // ステージと武器一覧のTableViewの初期設定
        tweetTableView.dataSource = self
        tweetTableView.delegate = self
        let nib = UINib.init(nibName: "TweetTableViewCell", bundle: nil)
        tweetTableView.register(nib, forCellReuseIdentifier: "TweetTableViewCell")
        
        // TableViewの高さ自動計算
        tweetTableView.estimatedRowHeight = 300
        tweetTableView.rowHeight = UITableViewAutomaticDimension
        
        // 引っ張ってリロードする設定
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        // インジケータの色を白に設定
        loadingView.tintColor = UIColor.white
        
        TwitterAPIManager.getlist(completion: {
            
        })
        
        tweetTableView.dg_addPullToRefreshWithActionHandler({
            TwitterAPIManager.getTimeLine(completion: {
                DispatchQueue.main.async {
                    self.tweetTableView.reloadData()
                    self.tweetTableView.dg_stopLoading()
                }
            })
//            self.getFavorite()
        }, loadingView: loadingView)
        tweetTableView.dg_setPullToRefreshFillColor(ConstColor.skyBlue)
        tweetTableView.dg_setPullToRefreshBackgroundColor(tweetTableView.backgroundColor!)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        TwitterAPIManager.getTimeLine(completion: {
            DispatchQueue.main.async {
                self.tweetTableView.reloadData()
            }
        })
//        getFavorite()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // ツイートボタン押下時の処理
    func tweet() {
        let viewController = storyboard?.instantiateViewController(withIdentifier: TweetViewController.nibName)
        self.present(viewController!, animated: true, completion: nil)
    }
    
    // 端末に登録されているTwitterアカウント取得
    private func selectTwitterAccount() {
        
        let manager = AccountStoreManager.shared
        let accountType = manager.accountType()
        
        manager.accountStore.requestAccessToAccounts(with: accountType, options: nil, completion: { (granted, error) -> Void in
           
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
                manager.account = manager.accountStore.account(withIdentifier: accountIdentifire as! String)
            } else {
                guard let accounts = manager.accountStore.accounts(with: accountType) else {
                    return
                }
                
                self.chooseAccount(accounts: (accounts as? [ACAccount])!)
            }
            
        })
    }
    
    
    /// 複数のTwitterアカウントから選択したアカウントを自身のプロパティにセットする
    ///
    /// - Parameter accounts: 端末に登録されているTiwtterアカウント配列
    private func chooseAccount(accounts: [ACAccount]){
        let manager = AccountStoreManager.shared
        DispatchQueue.main.sync {
            let alert = UIAlertController(title: "Twitter", message: "Choose an account", preferredStyle: .actionSheet)
            
            for account in accounts {
                alert.addAction(UIAlertAction(title: account.username,
                                              style: .default,
                                              handler: { (action) -> Void in
                                                
                                                // 自身のプロパティにセット
                                                manager.account = account
                                                
                                                // アカウントIDをNSURLDefaultsで永続化
                                                let userDefaults = UserDefaults.standard
                                                userDefaults.set(account.identifier, forKey: "account")
                                                
                                                TwitterAPIManager.getTimeLine(completion: {
                                                    DispatchQueue.main.async {
                                                        self.tweetTableView.reloadData()
                                                    }
                                                })
                }))
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

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
        return TwitterAPIManager.tweetList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath) as! TweetTableViewCell
        
        // MARK: セルのセットアップ
        
        cell.delegate = self
        
        // TweetEntityの並びでセルにデータをセット
        if TwitterAPIManager.tweetList.count > 0 {
            let tweet = TwitterAPIManager.tweetList[indexPath.row]
            DispatchQueue.main.async {
                cell.setup(entity: tweet)
            }
        }
        
        return cell
    }
}


extension ViewController: UITableViewDelegate {}


extension ViewController: UISearchBarDelegate {
    // TODO: サーチバーに入力した文字でTweetを検索しテーブルビューに表示
}

extension ViewController: TweetTableViewCellDelegate {
    
    // お気に入りメソッドをコール
    func pressdFavorite(cell: TweetTableViewCell) {
        let indexPath = tweetTableView.indexPath(for: cell)
        if let id =  TwitterAPIManager.tweetList[(indexPath?.row)!].id {
            TwitterAPIManager.postFavorite(id: id)
        }
    }
    
    // お気に入り解除メソッドをコール
    func pressdUnFavorite(cell: TweetTableViewCell) {
        let indexPath = tweetTableView.indexPath(for: cell)
        if let id = TwitterAPIManager.tweetList[(indexPath?.row)!].id {
            TwitterAPIManager.postUnFavorite(id: id)
        }
    }
    
    func pressdReply(cell: TweetTableViewCell) {
        let indexPath = tweetTableView.indexPath(for: cell)
        if let userID = TwitterAPIManager.tweetList[(indexPath?.row)!].userID {
            let viewController = storyboard?.instantiateViewController(withIdentifier: TweetViewController.nibName) as! TweetViewController
            // 選択したセルのユーザIDをリプライ画面のプロパティにセット
            viewController.userID = userID
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    func pressdRetweet(cell: TweetTableViewCell) {
        
    }
    
    func pressdUpperLeftImage(url: String) {
        // 画面遷移して画像を表示
        let viewController = ImageViewController()
        let imageView = UIImageView.init(frame: UIScreen.main.bounds)
        imageView.af_setImage(withURL: URL(string: url)!)
        viewController.view.addSubview(imageView)
        present(viewController, animated: true, completion: nil)
    }
    
}
