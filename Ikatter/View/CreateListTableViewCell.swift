//
//  CreateListTableViewCell.swift
//  Ikatter
//
//  Created by 南　京兵 on 2017/06/19.
//  Copyright © 2017年 南　京兵. All rights reserved.
//

import UIKit

class CreateListTableViewCell: UITableViewCell {
    
    static let nibName = "CreateListTableViewCell"
    
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
