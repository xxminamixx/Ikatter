//
//  RealmManager.swift
//  Ikatter
//
//  Created by 南　京兵 on 2017/06/06.
//  Copyright © 2017年 南　京兵. All rights reserved.
//

import RealmSwift

class RealmManager: NSObject {
    
    static let shared = RealmManager()
    
    lazy var realm = try! Realm()
    
    
    func add(object: AccountDefaultListEntity) {
        try! realm.write {
            realm.add(object, update: true)
        }
    }
    
    
    /// 更新処理
    ///
    /// - Parameter closure: AccountDefaultListEntityのプロパティ変更処理
    func update(_ closure: () -> Void) {
        try! realm.write {
            closure()
        }
    }
    
    /// AccountDefaultListEntity配列を返す
    func allObject() -> Results<AccountDefaultListEntity> {
        try! realm.objects(self.AccountDefaultListEntity)
    }
    
    func getEntity(id: String)  {
//        let a = allObject().filter("accounID == %@", id)
    }
    
    // アカウント情報Entityを永続化
    // Entity
    // list id
    // アカウントID
    
    // 起動時AccountStroeのアカウントIDを永続化
    // リストがタップされたときに、現在のアカウントをRealmから検索し、listプロパティを更新
    // UserDefaultで永続化しているアカウントIDをRealmから検索し、そのEntityのlistIDを表示する

}
