//
//  SecurityMenuItemCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 16.03.2022.
//

import UIKit

class SecurityMenuItemCell: UITableViewCell {
    @IBOutlet weak var itemIcon: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    
    var item:MenuItem<SecurityItemType>!
    
    func initialize(option:MenuItem<SecurityItemType>){
        item = option
        itemIcon.image = UIImage(systemName: option.iconName)
        itemTitle.text = item.itemTitle
        
        if !item.isEnabled{
            itemTitle.textColor = .darkGray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
