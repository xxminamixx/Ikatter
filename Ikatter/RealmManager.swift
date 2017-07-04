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
    
    override init() {
        realm = try! Realm()
    }
    
    var realm: Realm!
    
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
        return realm.objects(AccountDefaultListEntity.self)
    }
    
    /// 指定されたアカウントIDのEntityを返す
    ///
    /// - Parameter id: アカウント
    /// - Returns: アカウントに紐づいたAccountDefaultListEntity
    func getEntity(id: String) -> AccountDefaultListEntity? {
        guard let entity = realm.object(ofType: AccountDefaultListEntity.self, forPrimaryKey: id) else {
            return nil
        }
        return entity
    }
    
    /// 指定したアカウントIDのエンティティが存在するか判定
    ///
    /// - Parameter id: アカウントID
    /// - Returns: アカウントIDに紐づいたエンティティの有無
    func isExist(id: String) -> Bool {
        guard getEntity(id: id) != nil else {
            return false
        }
        
        return true
    }

}
