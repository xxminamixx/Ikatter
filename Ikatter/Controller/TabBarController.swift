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
    }

}


extension UITabBarController: UITabBarControllerDelegate {
    
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is DummyViewController {
            // DummyViewControllerはモーダルを出したい特定のタブに紐付けたViewController
            if let currentVC = self.selectedViewController {
                // 現在のViewControllerにAccountTableViewControllerを表示
                let navigationController = AccountNavigationController()
                let accountTableViewController = AccountTableViewController()
                navigationController.addChildViewController(accountTableViewController)
                currentVC.present(navigationController, animated: true, completion: nil)
            }
            return false
        } else if viewController is ListDummyViewController && !(self.selectedViewController is ListDummyViewController){
            // list表示用のダミーViewControllerだった場合 且つ 表示中のViewControllerがlist表示ViewControllerじゃない時
            if let currentVC = self.selectedViewController {
                
                // 現在のViewControllerにListTableViewControllerをモーダル表示
                let navigationController = ListNavigationController()
                let listTableViewController = ListTableViewController()
                
                // リストセルのタップ時のDelegateをViewControllerに設定
                let parentNavigationController = currentVC as! UINavigationController
                listTableViewController.delegate = parentNavigationController.childViewControllers.first as! ViewController
                
                navigationController.addChildViewController(listTableViewController)
                currentVC.present(navigationController, animated: true, completion: nil)
            }
        }
        
        return true
    }
    
}
