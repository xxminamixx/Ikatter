//
//  AddListMemberCollectionViewCell.swift
//  Ikatter
//
//  Created by 南　京兵 on 2017/06/19.
//  Copyright © 2017年 南　京兵. All rights reserved.
//

import UIKit
import AlamofireImage

class AddListMemberCollectionViewCell: UICollectionViewCell {
    
    static let nibName = "AddListMemberCollectionViewCell"
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var baseView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(entity: UserEntity) {
        baseView.backgroundColor = UIColor.white
        name.text = entity.name
        text.text = entity.text
        if let icon = entity.icon {
            self.icon.af_setImage(withURL: URL(string: icon)!)
        }
        
        // チェックフラグがnil、またはfalseのときretrun
        guard entity.isSelected else {
            return
        }
        
        baseView.backgroundColor = UIColor.gray
    }
    
}
