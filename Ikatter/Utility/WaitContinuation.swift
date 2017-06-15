//
//  WaitContinuation.swift
//  Ikatter
//
//  Created by 南　京兵 on 2017/06/15.
//  Copyright © 2017年 南　京兵. All rights reserved.
//

import UIKit

class WaitContinuation {

    /// 条件をクリアするまで待ちます
    ///
    /// - Parameters:
    ///   - waitContinuation: 待機条件
    ///   - compleation: 通過後の処理
    static func wait(_ waitContinuation: @escaping (()->Bool), compleation: @escaping (()->Void)) {
        var wait = waitContinuation()
        // 0.01秒周期で待機条件をクリアするまで待ちます。
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            while wait {
                DispatchQueue.main.async {
                    wait = waitContinuation()
                    semaphore.signal()
                }
                semaphore.wait()
                Thread.sleep(forTimeInterval: 0.01)
            }
            // 待機条件をクリアしたので通過後の処理を行います。
            DispatchQueue.main.async {
                compleation()
            }
        }
    }

    
}
