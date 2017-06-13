//
//  TabBarController.swift
//  Ikatter
//
//  Created by 南　京兵 on 2017/06/13.
//  Copyright © 2017年 南　京兵. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if viewController is DummyViewController {
//            // DummyViewControllerはモーダルを出したい特定のタブに紐付けたViewController
//            if let currentVC = self.selectedViewController{
//                //表示させるモーダル
//                let modalViewController: UIViewController = UIViewController()
//                //わかりやすく背景を赤色に
//                modalViewController.view.backgroundColor = UIColor.red
//                currentVC.present(modalViewController, animated: true, completion: nil)
//            }
//            return false
//        }
//        return true
//    }


}


extension UITabBarController: UITabBarControllerDelegate {
    
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is DummyViewController {
            // DummyViewControllerはモーダルを出したい特定のタブに紐付けたViewController
            if let currentVC = self.selectedViewController{
                //表示させるモーダル
                let modalViewController: UIViewController = UIViewController()
                //わかりやすく背景を赤色に
                modalViewController.view.backgroundColor = UIColor.red
                currentVC.present(modalViewController, animated: true, completion: nil)
            }
            return false
        }
        return true
    }
    
}
