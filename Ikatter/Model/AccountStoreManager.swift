//
//  AccountStoreManager.swift
//  Ikatter
//
//  Created by 南　京兵 on 2017/06/12.
//  Copyright © 2017年 南　京兵. All rights reserved.
//

import UIKit
import Accounts
import Swifter

class AccountStoreManager {
    static let shared = AccountStoreManager()
    var accountStore = ACAccountStore()
    var account: ACAccount?
}
