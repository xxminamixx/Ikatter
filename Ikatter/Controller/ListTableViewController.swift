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
        let nib = UINib.init(nibName: ListTableViewCell.nibName, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: ListTableViewCell.nibName)
        
        let rightCloseButon = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(close))
        navigationItem.setRightBarButtonItems([rightCloseButon], animated: true)

        
        TwitterAPIManager.getlist {
            self.tableView.reloadData()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 自身を閉じる
    func close() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: TableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TwitterAPIManager.listList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.row == TwitterAPIManager.listList.count + 1 {
            // 一番下のセルのとき、リスト作成用のセルを表示
            let cell = UITableViewCell()
            let label = UILabel()
            label.text = "＋新しいリストを作る"
            cell.addSubview(label)
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
    
    // MARK: TableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == TwitterAPIManager.listList.count + 1 {
            // TODO: リスト作成画面遷移処理
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
