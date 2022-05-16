//
//  SmallRequestCollectionviewCollectionViewCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 16.05.2022.
//

import UIKit

class SmallRequestCollectionviewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var userPhotoUIImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userPhotoUIImageView.isHidden = true
    }
    
    func setup(_ user:RequestUser) {
        FireStoreService.shared.getUserPhotoURL(user.userUid, onCompletion: { (url:String?) in
            print(url)
            self.userPhotoUIImageView.isHidden = false
            self.userPhotoUIImageView.setImage(urlString: url,
                                               radius: 10,
                                               focustStatus: false)
        })
    }
}
