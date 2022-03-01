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
    
    func initialize(option:ProfileOuterOption){
        self.optionIcon.image = UIImage(systemName: option.iconName)
        self.optionTextLabel.text = option.optionTitle
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
