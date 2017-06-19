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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(entity: UserEntity) {
        name.text = entity.name
        text.text = entity.text
        if let icon = entity.icon {
            self.icon.af_setImage(withURL: URL(string: icon)!)
        }
        
        // チェックフラグがnil、またはfalseのときretrun
        guard let isChecked = entity.isSelected, isChecked else {
            return
        }
        
        // TODO: うまく表示できないので修正する
        // チェックされていたらチェックビューを表示する
        let checkView = UIView()
        checkView.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.5)
        icon.addSubview(checkView)
        
        self.layoutIfNeeded()
    }
    
}
