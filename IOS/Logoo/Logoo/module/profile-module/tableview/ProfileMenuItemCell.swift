//
//  ProfileMenuItemCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 16.03.2022.
//

import UIKit

class ProfileMenuItemCell: UITableViewCell {

    @IBOutlet weak var itemIcon: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    
    var item:MenuItem<ProfileSettingType>!
    weak var delegate:ProfileMenuItemCellProtocol?
    
    func initialize(option:MenuItem<ProfileSettingType>){
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

protocol ProfileMenuItemCellProtocol : AnyObject {
    func onClick(model:MenuItem<ProfileSettingType>)
}