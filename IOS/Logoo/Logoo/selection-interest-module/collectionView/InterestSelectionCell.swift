//
//  InterestSelectionCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 12.02.2022.
//

import UIKit
import M13Checkbox

class InterestSelectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var checkBoxContainer: UIView!
    @IBOutlet weak var interestTitle: UILabel!
    var checkBox:M13Checkbox!
    var item:InterestSelectionModel!
    
    var indexPath:IndexPath?
    var cellToVC:InterestSelectCellToViewProtocol?
    
    func initialize (item:InterestSelectionModel) {
        
        self.item = item
        
        for view in self.checkBoxContainer.subviews {
            view.removeFromSuperview()
        }
                
        if item.isSelected! {
            self.checkBox = checkBoxGenerator(state: .checked)
        }else {
            self.checkBox = checkBoxGenerator(state: .unchecked)
        }
        self.checkBox.addTarget(self, action: #selector(self.checkBoxStateChanged), for: .valueChanged)
        
        self.checkBoxContainer.addSubview(self.checkBox)
        self.interestTitle.text = item.interestTitle!
    }
    
    @objc func checkBoxStateChanged(sender : UITapGestureRecognizer) {
        if self.checkBox.checkState == .checked {
            self.item.isSelected = true
            cellToVC?.onClick(item: self.item!)
        }else {
            self.item.isSelected = false
            cellToVC?.onClick(item: self.item!)
        }
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
        myCheckBox.tintColor = UIColor(named: "black700")
       // myCheckBox.setCheckState(state, animated: true)
        myCheckBox.frame = self.checkBoxContainer.bounds
        return myCheckBox
    }
}

protocol InterestSelectCellToViewProtocol {
    func onClick(item:InterestSelectionModel)
}
