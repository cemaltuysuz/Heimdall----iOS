//
//  LGPhotoSlider.swift
//  Logoo
//
//  Created by cemal tüysüz on 7.04.2022.
//

import UIKit

@IBDesignable
class LGPhotoSlider: NibLoadableView {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var photoSliderCollectionView: UICollectionView!
        
    var userPosts:[UserPost]?

    override func awakeFromNib() {
        configure()
    }
    
    func configure(){
        configureUI()
        setupBindings()
    }
    
    func configureUI(){
        pageControl.isHidden = true
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

extension LGPhotoSlider : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPosts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let current = userPosts![indexPath.row]
        let cell = collectionView.dequeue(indexPath, type: LGPhotoSliderCell.self)
        cell.configure(post: current)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if pageControl.isHidden {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height + pageControl.frame.height)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offSet = scrollView.contentOffset.x
            let width = scrollView.frame.width
            let horizontalCenter = width / 2

            let page = Int(offSet + horizontalCenter) / Int(width)
            pageControl.currentPage = page
        }
    
}
// MARK: - Functions

extension LGPhotoSlider {
    func updateUserPosts(posts: [UserPost]) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if posts.count > 0 {
                strongSelf.userPosts = posts
                if posts.count > 1 {
                    strongSelf.pageControl.numberOfPages = posts.count
                    strongSelf.pageControl.isHidden = false
                }
                strongSelf.photoSliderCollectionView.reloadData()
            }
        }
        
    }
}



