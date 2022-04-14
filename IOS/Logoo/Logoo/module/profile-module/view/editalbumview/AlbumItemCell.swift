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
    
    @IBOutlet weak var plusButtonOutlet: UIButton!
    @IBOutlet weak var trashContainer: UIView!
    @IBOutlet weak var albumItemImageView: UIImageView!
    
    weak var delegate:AlbumItemCellProtocol?
    var post:UserPost?
    
    private func configureDefCell(){
        plusButtonOutlet.isHidden = true
        trashContainer.isHidden = false
        
        let tapGestureTrash = UITapGestureRecognizer(target: self, action: #selector(self.onClickTrash(_:)))
        trashContainer.isUserInteractionEnabled = true
        trashContainer.addGestureRecognizer(tapGestureTrash)
        
        let tapGesturePhoto = UITapGestureRecognizer(target: self, action: #selector(self.onPhotoClick(_:)))
        albumItemImageView.isUserInteractionEnabled = true
        albumItemImageView.addGestureRecognizer(tapGesturePhoto)
        albumItemImageView.removeDashedBorder()
    }
    
    func lastCellConfigure(){
        plusButtonOutlet.isHidden = false
        trashContainer.isHidden = true
        
        contentView.isUserInteractionEnabled = true
        let tapGestureContent = UITapGestureRecognizer(target: self, action: #selector(self.onPhotoInsert(_:)))
        contentView.addGestureRecognizer(tapGestureContent)
        albumItemImageView.addDashedBorder()
    }
    
    func configureCell(post:UserPost){
        configureDefCell()
        self.post = post
        if let url = post.postUrl {
            albumItemImageView.setImage(urlString: url)
        }
    }
}

extension AlbumItemCell {
    
    @objc
    func onClickTrash(_ tap:UITapGestureRecognizer) {
    }
    
    @objc func onPhotoClick(_ sender: Any) {
    }
    
    @objc func onPhotoInsert(_ tap:UITapGestureRecognizer) {
        delegate?.selectPhotoRequest()
    }
}
