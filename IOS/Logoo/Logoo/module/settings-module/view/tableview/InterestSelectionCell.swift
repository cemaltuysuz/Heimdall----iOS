//
//  InterestsTableViewCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 24.04.2022.
//

import UIKit
import M13Checkbox

class InterestSelectionCell: UITableViewCell {
    
    @IBOutlet weak var checkBoxContainer: UIView!
    @IBOutlet weak var interestTitle: UILabel!
    var checkBox:M13Checkbox!
    var item:Interest!
    weak var delegate:InterestActionCellProtocol?
    var indexPath:IndexPath?
    
    func initialize (item:Interest, isSelected:Bool) {
        self.item = item
        
        for view in self.checkBoxContainer.subviews {
            view.removeFromSuperview()
        }
        
        if isSelected {
            checkBox = checkBoxGenerator(state: .checked)
        }else {
            checkBox = checkBoxGenerator(state: .unchecked)
        }
        checkBox.addTarget(self, action: #selector(self.checkBoxStateChanged), for: .valueChanged)
        
        checkBoxContainer.addSubview(self.checkBox)
        interestTitle.text = getLanguageCode == "tr" ? item.interestTR : item.interestEN
    }
    
    @objc
    func checkBoxStateChanged(sender : UITapGestureRecognizer) {
        if checkBox.checkState == .checked {
            delegate?.onClickItem(item: item, isInsertAction: true)
            return
        }
        delegate?.onClickItem(item: item, isInsertAction: false)
    }
    
    func onClick(indexPath: IndexPath) {
        self.indexPath = indexPath
    }
    
    func checkBoxGenerator(state:M13Checkbox.CheckState)-> M13Checkbox {
        let myCheckBox = M13Checkbox()
        myCheckBox.boxType = .square
        myCheckBox.markType = .checkmark
        myCheckBox.stateChangeAnimation = .expand(.fill)
        myCheckBox.checkState = state
        myCheckBox.tintColor = Color.black700 ?? UIColor.black
        myCheckBox.frame = checkBoxContainer.bounds
        
        return myCheckBox
    }
}
