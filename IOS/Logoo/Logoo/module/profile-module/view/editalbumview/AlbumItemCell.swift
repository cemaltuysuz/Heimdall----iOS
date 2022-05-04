//
//  AlbumItemCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 12.04.2022.
//

import UIKit
import ImageViewer_swift


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
        
        albumItemImageView.image = nil
        
        let tapGestureTrash = UITapGestureRecognizer(target: self, action: #selector(self.onClickTrash(_:)))
        trashContainer.isUserInteractionEnabled = true
        trashContainer.addGestureRecognizer(tapGestureTrash)
        
        albumItemImageView.removeDashedBorder()
    }
    
    func firstCellConfigure(){
        plusButtonOutlet.isHidden = false
        trashContainer.isHidden = true
        albumItemImageView.image = nil
        albumItemImageView.isUserInteractionEnabled = false
        
        contentView.isUserInteractionEnabled = true
        let tapGestureContent = UITapGestureRecognizer(target: self, action: #selector(self.onPhotoInsert(_:)))
        contentView.addGestureRecognizer(tapGestureContent)
        
        albumItemImageView.layer.masksToBounds = false
        albumItemImageView.layer.cornerRadius = 0
        albumItemImageView.removeDashedBorder()
        albumItemImageView.addDashedBorder(radius: contentView.layer.cornerRadius)
    }
    
    func configureCell(post:UserPost){
        configureDefCell()
        self.post = post
        if let url = post.postUrl {
            albumItemImageView.setImage(urlString: url, radius: 10, focustStatus: true)
        }
    }
    @IBAction func plusOnClick(_ sender: Any) {
        delegate?.selectPhotoRequest()
    }
}

extension AlbumItemCell {
    
    @objc
    func onClickTrash(_ tap:UITapGestureRecognizer) {
        guard let post = post, let uid = post.postUUID else {return}
        delegate?.deletePhotoRequest(postUUID: uid)
    }

    @objc func onPhotoInsert(_ tap:UITapGestureRecognizer) {
        delegate?.selectPhotoRequest()
    }
}
