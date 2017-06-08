//
//  LinkHelper.swift
//  Ikatter
//
//  Created by 南　京兵 on 2017/06/08.
//  Copyright © 2017年 南　京兵. All rights reserved.
//

import UIKit

class LinkHelper: NSObject {
    class func extractURL(_ string:String)-> [URL]{
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let links = detector.matches(in: string, range: NSMakeRange(0, string.characters.count))
        return links.flatMap { $0.url }
    }
}
