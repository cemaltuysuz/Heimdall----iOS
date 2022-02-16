//
//  InsterestSelectedCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 16.02.2022.
//

import UIKit

class InterestSelectedCell: UICollectionViewCell {
    @IBOutlet weak var interestTitleLabel: UILabel!
    var deSelect:InterestSelectCellToViewProtocol?
    var title:String!
    
    func initialize(row:String) {
        interestTitleLabel.text = row
        title = row
    }
    @IBAction func interestDeselectButton(_ sender: Any) {
        deSelect?.onClick(item: InterestSelectionModel(title: title,
                                                       status: false))
    }
}
