//
//  OnBoardCollectionCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 20.01.2022.
//

import UIKit

class OnBoardCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var onBoardImage: UIImageView!
    @IBOutlet weak var onBoardTitleLabel: UILabel!
    @IBOutlet weak var onBoardDescriptionLabel: UITextView!
    
    func initializeCell(onBoard:OnBoard){
        onBoardImage.image = onBoard.image
        onBoardTitleLabel.text = onBoard.title
        onBoardDescriptionLabel.text = onBoard.description
    }
}
