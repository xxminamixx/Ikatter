//
//  AccountDefaultListEntity.swift
//  Ikatter
//
//  Created by 南　京兵 on 2017/06/26.
//  Copyright © 2017年 南　京兵. All rights reserved.
//

import UIKit
import RealmSwift

class AccountDefaultListEntity: Object {
    dynamic var listID: String?
    dynamic var listName: String?
    dynamic var accountID: String?
    
    override static func primaryKey() -> String? {
        return "accountID"
    }
}
