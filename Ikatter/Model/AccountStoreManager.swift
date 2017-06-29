//
//  AccountStoreManager.swift
//  Ikatter
//
//  Created by 南　京兵 on 2017/06/12.
//  Copyright © 2017年 南　京兵. All rights reserved.
//

import UIKit
import Accounts

class AccountStoreManager {
    static let shared = AccountStoreManager()
    var accountStore = ACAccountStore()
    var account: ACAccount?
    
    func accountType() -> ACAccountType? {
        return accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
    }
    
    
    /// アカウントが永続化されているか判定
    ///
    /// - Returns: true: アカウントが永続化済み, false: アカウントが永続化されていない
    func isSavedAccount() -> Bool {
        guard let _ = UserDefaults.standard.object(forKey: "account") else {
            return false
        }
        
        return true
    }
    
    // 端末に登録されているTwitterアカウント取得
    func getDeviceTwitterAccounts(completion: @escaping () -> Void) {
        
        accountStore.requestAccessToAccounts(with: accountType(), options: nil, completion: { (granted, error) -> Void in
            
            // エラー発生
            guard error == nil else {
                return
            }
            
            // アカウントの利用許可がされていない
            guard granted else {
                return
            }
            
            completion()
        })
    }
    
    /// 永続化されているアカウントがある場合は自身のプロパティにセットする
    func setAccount(completion: () -> Void) {
        if let accountIdentifire = UserDefaults.standard.object(forKey: "account") {
            account = accountStore.account(withIdentifier: accountIdentifire as! String)
            completion()
        }
    }
    
    /// アカウントストアを配列にして返す
    ///
    /// - Returns: ACAccount配列
    func getAccounts() -> [ACAccount]? {
        return (accountStore.accounts(with: accountType()) as? [ACAccount]!)
    }
    
    
    /// 現在のアカウントIDを返却する
    ///
    /// - Returns: アカウントID
    func getIdentifier() -> String {
        return (AccountStoreManager.shared.account?.identifier)! as String
    }

}
