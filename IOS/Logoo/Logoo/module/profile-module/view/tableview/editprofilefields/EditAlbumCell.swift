//
//  EditAlbumCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 12.04.2022.
//

import UIKit

protocol EditAlbumCellProtocol : AnyObject {
    func selectPhotoRequest()
    func deletePhotoRequest(postUUID:String)
}

class EditAlbumCell: UITableViewCell {

    @IBOutlet weak var albumCollectionView: UICollectionView!
    weak var delegate:EditAlbumCellProtocol?
    
    private var posts:[UserPost]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func configureUI(){
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        albumCollectionView.collectionViewLayout = layout
    }
    
}

extension EditAlbumCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath, type: AlbumItemCell.self)
        return cell
    }
}

// EditAlbumCell <- AlbumItemCell
extension EditAlbumCell : AlbumItemCellProtocol {
    func selectPhotoRequest() {
        delegate?.selectPhotoRequest()
    }
    
    func deletePhotoRequest(postUUID:String) {
        delegate?.deletePhotoRequest(postUUID: postUUID)
    }
}

// EditAlbumCell <- EditProfileVC
extension EditAlbumCell : EditProfileVCToAlbumCellProtocol {
    func updateData(posts: [UserPost]) {
        DispatchQueue.main.async {
            self.posts = posts
            self.albumCollectionView.reloadData()
        }
    }
}
