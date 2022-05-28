//
//  SmallRequestCollectionviewCollectionViewCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 16.05.2022.
//

import UIKit

class SmallRequestCollectionviewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var userPhotoUIImageView: UIImageView!
    var onClicked: (Request) -> () = {_ in}
    var request:Request?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userPhotoUIImageView.isHidden = true
        userPhotoUIImageView.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.onClicked(_:)))
        userPhotoUIImageView.addGestureRecognizer(recognizer)
    }
    
    func setup(_ request:Request) {
        self.request = request
        FireStoreService.shared.getUserPhotoURL(request.senderId, onCompletion: { (url:String?) in
            self.userPhotoUIImageView.isHidden = false
            self.userPhotoUIImageView.setImage(urlString: url,
                                               radius: 10,
                                               focustStatus: false)
        })
    }
    
    @objc func onClicked(_ recognizer:UITapGestureRecognizer) {
        guard let request = request else {
            return
        }

        onClicked(request)
    }
}
