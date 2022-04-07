//
//  LGPhotoSlider.swift
//  Logoo
//
//  Created by cemal tüysüz on 7.04.2022.
//

import UIKit


class LGPhotoSlider: UIView {
    @IBOutlet weak var leftClickButton: UIButton!
    @IBOutlet weak var leftClickArea: UIView!
    @IBOutlet weak var rightClickButton: UIButton!
    @IBOutlet weak var rightClickArea: UIView!
    @IBOutlet weak var photoSliderCollectionView: UICollectionView!
        
    var userPosts:[UserPost]? {
        didSet{
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                if !(strongSelf.userPosts?.isEmpty ?? true) {
                    return
                }
                strongSelf.photoSliderCollectionView.reloadData()
            }
        }
    }

    override func awakeFromNib() {
        configureUI()
        setupBindings()
    }
    
    func configureUI(){
        leftClickButton.isEnabled = false
        leftClickArea.isUserInteractionEnabled = false
        rightClickArea.isUserInteractionEnabled = true
        photoSliderCollectionView.isPagingEnabled = true
        photoSliderCollectionView.showsHorizontalScrollIndicator = false
    }
    
    func setupBindings(){
        photoSliderCollectionView.register(LGPhotoSliderCell.self)
        photoSliderCollectionView.dataSource = self
        photoSliderCollectionView.delegate = self
    }

}
// MARK: - UICollectionView methods

extension LGPhotoSlider : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPosts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let current = userPosts![indexPath.row]
        let cell = collectionView.dequeue(indexPath, type: LGPhotoSliderCell.self)
        cell.configure(post: current)
        return cell
    }
}
// MARK: - Functions

extension LGPhotoSlider {
    func updateUserPosts(posts: [UserPost]) {
        userPosts = posts
    }
}



