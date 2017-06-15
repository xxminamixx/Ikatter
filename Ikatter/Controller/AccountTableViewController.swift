//
//  AccountTableViewController.swift
//  Ikatter
//
//  Created by 南　京兵 on 2017/06/15.
//  Copyright © 2017年 南　京兵. All rights reserved.
//

import UIKit
import Accounts
import Swifter
import AlamofireImage

class AccountTableViewController: UITableViewController {

    var accounts: [ACAccount]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Twitterアカウントをプロパティにセット
        let manager = AccountStoreManager.shared
        let accountType = manager.accountType()
        accounts = manager.accountStore.accounts(with: accountType) as? [ACAccount]
        
        // tableView初期設定
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib.init(nibName: AccountTableViewCell.nibName, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: AccountTableViewCell.nibName)
        
        let rightCloseButon = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(close))
        navigationItem.setRightBarButtonItems([rightCloseButon], animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 自身を閉じる
    func close() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AccountStoreManager.shared.accountStore.accounts(with: AccountStoreManager.shared.accountType()).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountTableViewCell.nibName, for: indexPath) as! AccountTableViewCell
        
        // セルにアカウントから取得したユーザ名をセット
        cell.name.text = accounts?[indexPath.row].username
        
        guard let account = AccountStoreManager.shared.account else {
            // アカウントが取得できなかった場合はユーザ名だけセットされた状態で返す
            return cell
        }
        
        // アイコンをセット
        TwitterAPIManager.getUserIcon(account: account, completion: { (icon: String?) in
            guard let safeIcon = icon else {
                return
            }
            cell.icon.af_setImage(withURL:  URL(string: safeIcon)!)
        })
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 選択されたセルのアカウントをAccountStoreManagerのプロパティにセット
        AccountStoreManager.shared.account = accounts?[indexPath.row]
        // 自身を閉じる
        dismiss(animated: true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
