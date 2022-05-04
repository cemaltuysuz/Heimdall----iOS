//
//  InsterestSelectedCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 16.02.2022.
//

import UIKit

protocol InterestActionCellProtocol : AnyObject {
    func onClickItem(item:Interest, isInsertAction:Bool)
}

class InterestSelectedCell: UICollectionViewCell {
    @IBOutlet weak var interestTitleLabel: UILabel!
    weak var delegate:InterestActionCellProtocol?
    var item:Interest!
    
    func initialize(item:Interest) {
        self.item = item
        interestTitleLabel.text = getLanguageCode == "tr" ? item.interestTR : item.interestEN
    }
    
    @IBAction func interestDeselectButton(_ sender: Any) {
        delegate?.onClickItem(item: item,
                              isInsertAction: false)
    }
}

