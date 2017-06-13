//
//  UITextViewExtension.swift
//  Ikatter
//
//  Created by 南　京兵 on 2017/06/13.
//  Copyright © 2017年 南　京兵. All rights reserved.
//

import UIKit

extension UITextView {
    
    /**
     現在のキャレットの位置をoffset分ずらす
     
     :param: offset Int ずらす量
     
     :returns: bool 成功か失敗
     */
    func changeCaret(_ offset:Int) -> Bool {
        
        // 全角文字を確定状態にする
        let nowText = self.text
        self.text = nowText
        
        if let range = self.selectedTextRange {
            let position = self.position(from: range.start, offset: offset)
            
            self.selectedTextRange = self.textRange(from: position!, to: position!)
            
            return true
        }
        
        return false
    }
}
