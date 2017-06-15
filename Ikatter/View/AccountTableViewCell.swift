//
//  AccountTableViewCell.swift
//  Ikatter
//
//  Created by 南　京兵 on 2017/06/15.
//  Copyright © 2017年 南　京兵. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    static let nibName = "AccountTableViewCell"
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
