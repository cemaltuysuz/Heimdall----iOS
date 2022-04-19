//
//  EditAlbumView.swift
//  Logoo
//
//  Created by cemal tüysüz on 13.04.2022.
//

import Foundation
import UIKit

protocol EditPostAlbumViewProtocol : AnyObject {
    func selectPhotoRequest()
    func deletePhotoRequest(postUUID:String)
}

class EditPostAlbumView : NibLoadableView {
    
    @IBOutlet weak var postsCollectionView: UICollectionView!
    
    weak var delegate:EditPostAlbumViewProtocol?
    let lineHeight:CGFloat = 240
    private var posts:[UserPost]?
    
    override func awakeFromNib() {
        postsCollectionView.register(AlbumItemCell.self)
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
        configureUI()
    }
    
    func configureUI(){
        postsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 15)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        postsCollectionView.collectionViewLayout = layout
    }
}

extension EditPostAlbumView : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let posts = posts else {return 1}
        return posts.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath, type: AlbumItemCell.self)
        cell.delegate = self
        if indexPath.row == 0 {
            cell.lastCellConfigure()
            return cell
        }
        let post = posts![indexPath.row - 1]
        cell.configureCell(post: post)
        return cell
    }
}

// EditAlbumCell <- AlbumItemCell
extension EditPostAlbumView : AlbumItemCellProtocol {
    func selectPhotoRequest() {
        delegate?.selectPhotoRequest()
    }
    
    func deletePhotoRequest(postUUID:String) {
        delegate?.deletePhotoRequest(postUUID: postUUID)
    }
}

// EditAlbumCell <- EditProfileVC
extension EditPostAlbumView : EditProfileVCToEditAlbumViewProtocol {
    func updateData(posts: [UserPost]) {
        DispatchQueue.main.async {
            self.posts = posts
            self.postsCollectionView.reloadData()
        }
    }
}
