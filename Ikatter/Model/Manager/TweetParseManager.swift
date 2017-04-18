//
//  TweetParseManager.swift
//  Ikatter
//
//  Created by 南　京兵 on 2017/04/18.
//  Copyright © 2017年 南　京兵. All rights reserved.
//

import UIKit

class TweetParseManager {
    
    static func jsonParser(json: Data) {
        let a = try! JSONSerialization.jsonObject(with: json, options: JSONSerialization.ReadingOptions.allowFragments)
        if let jsonDic = a as? NSDictionary {
            print(jsonDic)
        }
        
    }
}
    
