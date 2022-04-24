//
//  InterestViewerCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 8.04.2022.
//

import UIKit

class InterestViewerCell: UICollectionViewCell {

    @IBOutlet weak var interestLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func congfigureCell(interest:String) {
        interestLabel.text = interest
    }
}
