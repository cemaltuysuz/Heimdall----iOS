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
    weak var delegate:SecurityMenuItemCellProtocol?
    
    func initialize(option:MenuItem<SecurityItemType>){
        item = option
        itemIcon.image = UIImage(systemName: option.iconName)
        itemTitle.text = item.itemTitle
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.onSettingClick(recognizer:)))
        self.contentView.addGestureRecognizer(recognizer)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc
    func onSettingClick(recognizer:UITapGestureRecognizer){
        delegate?.onClick(model: item)
    }
}

protocol SecurityMenuItemCellProtocol : AnyObject {
    func onClick(model:MenuItem<SecurityItemType>)
}
