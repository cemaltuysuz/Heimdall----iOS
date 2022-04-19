//
//  InterestSelectTableViewCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 12.02.2022.
//

import UIKit
import M13Checkbox

class InterestSelectTableViewCell: UITableViewCell {
    @IBOutlet weak var CheckBoxContainer: UIView!
    @IBOutlet weak var InterestNameLabel: UILabel!
    var initValue:Bool = false
    
    func initialize (isSelected:Bool, name:String) {
        let checkBox = M13Checkbox()
        checkBox.frame = CheckBoxContainer.bounds
        checkBox.boxType = .square
        checkBox.markType = .checkmark
        checkBox.stateChangeAnimation = .fill
        initValue = isSelected
        if(initValue) {
            checkBox.checkState = .checked
        }else {
            checkBox.checkState = .unchecked
        }
        InterestNameLabel.text = name
        CheckBoxContainer.addSubview(checkBox)
        print("\(name) olustu \(isSelected) değeri.")
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
