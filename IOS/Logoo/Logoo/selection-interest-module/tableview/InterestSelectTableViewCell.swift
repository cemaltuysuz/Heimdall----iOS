//
//  InterestSelectTableViewCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 12.02.2022.
//

import UIKit

class InterestSelectTableViewCell: UITableViewCell {
    @IBOutlet weak var CheckBoxContainer: UIView!
    @IBOutlet weak var InterestNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
