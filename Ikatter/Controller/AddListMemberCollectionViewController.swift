//
//  AddListMemberCollectionViewController.swift
//  Ikatter
//
//  Created by 南　京兵 on 2017/06/19.
//  Copyright © 2017年 南　京兵. All rights reserved.
//

import UIKit

protocol AddListMemberCollectionViewControlerDelegate {
    func addedListMember(completion: () -> Void)
}

private let reuseIdentifier = "Cell"

class AddListMemberCollectionViewController: UICollectionViewController {
    
    var delegate: AddListMemberCollectionViewControlerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景色を白に設定
        self.collectionView?.backgroundColor = UIColor.white

        // コレクションビューの初期設定
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        collectionView?.isUserInteractionEnabled = true
        let nib = UINib.init(nibName: AddListMemberCollectionViewCell.nibName, bundle: nil)
        self.collectionView!.register(nib, forCellWithReuseIdentifier: AddListMemberCollectionViewCell.nibName)

        // NavigationBarの右に完了ボタンを追加
        let rightCompletionButon = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(completion))
        navigationItem.setRightBarButtonItems([rightCompletionButon], animated: true)
        
        // NavigationBarの左に閉じるボタンを追加
        let leftCloseButon = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(close))
        navigationItem.setLeftBarButtonItems([leftCloseButon], animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /// NavigationBarの右ボタンを押下した時の処理
    func completion() {
        // フォローユーザ配列からチェックがされているユーザのみを抽出
        let checkUsers = TwitterAPIManager.followingUserList.filter({$0.isSelected == true})
        // チェックされているユーザをリストに追加する
        for checkUser in checkUsers {
            let listID = UserDefaults.standard.object(forKey: "listID") as? String
            TwitterAPIManager.addListMember(userID: checkUser.id!, listID: listID!, completion: {})
        }
        
        // タイムラインを更新する
        delegate?.addedListMember(completion: {
            // モーダルを閉じる
            dismiss(animated: true, completion: nil)
        })
        
    }
    
    /// NacigationBarの左ボタンを押下した時の処理
    func close() {
        // 自身を閉じる
        dismiss(animated: true, completion: nil)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TwitterAPIManager.followingUserList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddListMemberCollectionViewCell.nibName , for: indexPath) as! AddListMemberCollectionViewCell
        
        let entity = TwitterAPIManager.followingUserList[indexPath.row]
        
        cell.setup(entity: entity)
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */
    
    override func collectionView(_: UICollectionView, didSelectItemAt: IndexPath) {
        // タップしたセルの選択フラグを立てる
        let entity = TwitterAPIManager.followingUserList[didSelectItemAt.row]
        entity.isSelected = true
        collectionView?.reloadData()
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
