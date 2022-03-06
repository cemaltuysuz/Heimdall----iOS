//
//  ProfileOuterOptionCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.02.2022.
//

import UIKit

class ProfileOuterOptionCell: UITableViewCell {

    @IBOutlet weak var optionIcon: UIImageView!
    @IBOutlet weak var optionTextLabel: UILabel!
    
    var optionModel:ProfileOuterOption!
    var delegate:ProfileOuterOptionCellProtocol?
    
    func initialize(option:ProfileOuterOption){
        self.optionModel = option
        self.optionIcon.image = UIImage(systemName: option.iconName)
        self.optionTextLabel.text = option.optionTitle
        
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
        delegate?.onClick(settingType: self.optionModel.userSettingType)
    }
}

protocol ProfileOuterOptionCellProtocol {
    func onClick(settingType:UserSettingType)
}
