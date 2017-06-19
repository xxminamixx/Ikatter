//
//  ListTableViewController.swift
//  Ikatter
//
//  Created by 南　京兵 on 2017/06/16.
//  Copyright © 2017年 南　京兵. All rights reserved.
//

import UIKit

protocol ListTableViewControllerDelegate {
    func listTapped(id: String, completion: @escaping () -> Void)
}

class ListTableViewController: UITableViewController {
    
    var delegate: ListTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableViewの初期設定
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let mainNib = UINib(nibName: ListTableViewCell.nibName, bundle: nil)
        self.tableView.register(mainNib, forCellReuseIdentifier: ListTableViewCell.nibName)
        let haederNib = UINib(nibName: CreateListTableViewCell.nibName, bundle: nil)
        self.tableView.register(haederNib, forCellReuseIdentifier: CreateListTableViewCell.nibName)
        
        // NavigationBarの右に確定ボタンを追加
        let rightCloseButon = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(close))
        navigationItem.setRightBarButtonItems([rightCloseButon], animated: true)
        // NavigationBarの左に編集ボタンを追加
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TwitterAPIManager.getlist {
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
    }
    
    // 自身を閉じる
    func close() {
        self.tabBarController?.selectedIndex = 0
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: TableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TwitterAPIManager.listList.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.row == TwitterAPIManager.listList.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: CreateListTableViewCell.nibName, for: indexPath) as! CreateListTableViewCell
            cell.name.text = "+新しいリストを作成する"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.nibName, for: indexPath) as! ListTableViewCell

            let entity = TwitterAPIManager.listList[indexPath.row]
            // リストの名前をセット
            cell.name.text = entity.name
            // リストの説明文をセット
            cell.subText.text = entity.description
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == TwitterAPIManager.listList.count {
            // リスト作成セルを編集不可にする
            return false
        } else {
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let id = TwitterAPIManager.listList[indexPath.row].id else {
            return
        }
        
        TwitterAPIManager.deleteList(id: id, completion: {
            // リスト管理配列からリストを削除
            TwitterAPIManager.listList.remove(at: indexPath.row)
            tableView.reloadData()
        })
        
    }
    
    // MARK: TableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == TwitterAPIManager.listList.count {
            // リスト作成画面へ遷移
            let navigationController = CreateListNavigationController()
            let viewController = CreateListViewController()
            viewController.delegate = self
            navigationController.addChildViewController(viewController)
            
            present(navigationController, animated: true, completion: nil)
        } else {
            guard let id = TwitterAPIManager.listList[indexPath.row].id else {
                return
            }
            // リストセルをタップした時のデリゲートコール
            delegate?.listTapped(id: id, completion: {
                // デリゲートメソッドの処理が終わったらモーダルを閉じる
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }

    }

}

extension ListTableViewController: CreateListViewControllerDelegate {
    
    func createList(name: String, text: String, isPublic: Bool) {
        // リスト作成APIの呼び出し
        TwitterAPIManager.createList(name: name, description: text, isPublic: isPublic, completion: {
            self.tableView.reloadData()
        })
    }
    
}
