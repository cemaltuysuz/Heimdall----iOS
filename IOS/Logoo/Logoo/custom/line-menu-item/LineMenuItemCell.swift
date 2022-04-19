//
//  LineMenuItemCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 8.04.2022.
//

import UIKit

protocol LineMenuItemCellProtocol : AnyObject {
    func onClickMenu(instance:LineMenuItem)
    func onClickWarning(instance:LineMenuItem)
}


class LineMenuItemCell: UITableViewCell  {
    
    weak var delegate:LineMenuItemCellProtocol?
    
    @IBOutlet weak var warningButtonOutlet: UIButton!
    @IBOutlet weak var menuTitleLabel: UILabel!
    @IBOutlet weak var menuIconUIImageView: UIImageView!
    
    var item:LineMenuItem?
    
    func initialize(item:LineMenuItem){
        self.item = item
        menuIconUIImageView.image = UIImage(systemName: item.iconName)
        menuTitleLabel.text = item.itemTitle
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.onMenuClick(recognizer:)))
        contentView.isUserInteractionEnabled = true
        contentView.addGestureRecognizer(recognizer)
        warningButtonOutlet.isHidden = !item.isWarningButtonEnabled
    }
    
    
    @objc
    func onMenuClick(recognizer:UITapGestureRecognizer){
        guard let item = item else {
            return
        }

        delegate?.onClickMenu(instance: item)
    }
    
    @IBAction func warningButton(_ sender: Any) {
        guard let item = item else {
            return
        }
        delegate?.onClickWarning(instance: item)
    }
}
