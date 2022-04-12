//
//  AlbumItemCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 12.04.2022.
//

import UIKit

protocol AlbumItemCellProtocol : AnyObject {
    func selectPhotoRequest()
    func deletePhotoRequest(postUUID:String)
}

class AlbumItemCell: UICollectionViewCell {
    
    @IBOutlet weak var trashContainer: UIView!
    @IBOutlet weak var albumItemImageView: UIImageView!
    
    weak var delegate:AlbumItemCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func configureUI(){
        if tag == 0 {
            trashContainer.isHidden = true
        }
        trashContainer.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onClickTrash(_:)))
        trashContainer.addGestureRecognizer(tapGesture)
    }
    
    func configureData(url:String){
        albumItemImageView.setImage(urlString: url)
    }
    
    @IBAction func onPhotoClick(_ sender: Any) {
        if tag == 0 {
            delegate?.selectPhotoRequest()
        }else {
            // TODO: PHOTO FOCUS
        }
    }
}

extension AlbumItemCell {
    
    @objc
    func onClickTrash(_ tap:UITapGestureRecognizer) {
        
    }
}
