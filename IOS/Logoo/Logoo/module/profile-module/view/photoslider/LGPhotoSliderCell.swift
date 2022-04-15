//
//  LGPhotoSliderCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 7.04.2022.
//

import UIKit

class LGPhotoSliderCell: UICollectionViewCell {
    

    @IBOutlet weak var userPostPhotoImageView: UIImageView!
    
    func configure(post:UserPost) {
        guard let url = post.postUrl else{return}
        userPostPhotoImageView.setImage(urlString: url)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
