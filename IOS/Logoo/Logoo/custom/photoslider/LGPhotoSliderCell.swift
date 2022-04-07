//
//  LGPhotoSliderCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 7.04.2022.
//

import UIKit

class LGPhotoSliderCell: UICollectionViewCell {
    

    @IBOutlet weak var userPostPhotoImageView: LGImageView!
    
    func configure(post:UserPost) {
        print(post.postUrl ?? "unfound")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
