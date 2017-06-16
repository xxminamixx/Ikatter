//
//  CreateListViewController.swift
//  Ikatter
//
//  Created by 南　京兵 on 2017/06/16.
//  Copyright © 2017年 南　京兵. All rights reserved.
//

import UIKit

protocol CreateListViewControllerDelegate {
    func createList(name: String, text: String, isPublic: Bool)
}

class CreateListViewController: UIViewController {

    /// リスト名
    @IBOutlet weak var name: UITextField!
    /// リスト説明文
    @IBOutlet weak var text: UITextView!
    /// 公開スイッチ
    @IBOutlet weak var isPublic: UISwitch!
    
    var delegate: CreateListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 閉じるボタンセット
        let leftCloseButon = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(close))
        navigationItem.setLeftBarButtonItems([leftCloseButon], animated: true)
        
        // リスト保存ボタンセット
        let rightSaveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(save))
        navigationItem.setRightBarButtonItems([rightSaveButton], animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 自身を閉じる
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func save() {
        // リスト作成APIの呼び出し
        delegate?.createList(name: name.text!, text: text.text, isPublic: isPublic.isOn)
    }

}
