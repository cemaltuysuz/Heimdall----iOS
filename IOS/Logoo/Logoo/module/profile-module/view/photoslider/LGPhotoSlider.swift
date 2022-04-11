//
//  LGPhotoSlider.swift
//  Logoo
//
//  Created by cemal tüysüz on 11.04.2022.
//

import Foundation
import UIKit

class LGPhotoSlider: NibLoadableView {
    
    @IBOutlet weak var rightButtonOutlet: UIButton!
    @IBOutlet weak var rightArea: UIView!
    @IBOutlet weak var leftButtonOutlet: UIButton!
    @IBOutlet weak var leftArea: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var photoSliderCollectionView: UICollectionView!
    
    var userPosts:[UserPost]?
    
    override func awakeFromNib() {
        configure()
    }
    
    private func configure(){
        configureUI()
        setupBindings()
    }
    
    private func configureUI(){
        pageControl.isHidden = true
        photoSliderCollectionView.isPagingEnabled = true
        photoSliderCollectionView.showsHorizontalScrollIndicator = false
        
        leftButtonOutlet.isHidden = false
        leftButtonOutlet.isEnabled = false
        rightButtonOutlet.isHidden = false
        rightButtonOutlet.isEnabled = true
    }
    
    private func setupBindings(){
        
        leftArea.isUserInteractionEnabled = true
        let leftTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.leftAreaOnClick(_:)))
        leftArea.addGestureRecognizer(leftTapGestureRecognizer)
        
        rightArea.isUserInteractionEnabled = true
        let rightTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.rightAreaOnClick(_:)))
        rightArea.addGestureRecognizer(rightTapGestureRecognizer)
        
        photoSliderCollectionView.register(LGPhotoSliderCell.self)
        photoSliderCollectionView.dataSource = self
        photoSliderCollectionView.delegate = self
    }
    
}


extension LGPhotoSlider {
    
    @objc
    func leftAreaOnClick(_ recognizer:UITapGestureRecognizer){
        scrollToPreviousItem()
    }
    
    @objc
    func rightAreaOnClick(_ recognizer:UITapGestureRecognizer){
        
        scrollToNextItem()
    }
}

extension LGPhotoSlider {
    
    func scrollToNextItem() {
        let rect = photoSliderCollectionView.layoutAttributesForItem(at: IndexPath(row: getCurrentPageIndex() + 1, section: 0))?.frame
        if let rect = rect {
            photoSliderCollectionView.scrollRectToVisible(rect, animated: true)
        }
    }
    
    func scrollToPreviousItem() {
        let rect = photoSliderCollectionView.layoutAttributesForItem(at: IndexPath(row: getCurrentPageIndex() - 1, section: 0))?.frame
        if let rect = rect {
            photoSliderCollectionView.scrollRectToVisible(rect, animated: true)
        }
    }
    
    func getCurrentPageIndex() -> Int{
        let offSet = photoSliderCollectionView.contentOffset.x
        let width = photoSliderCollectionView.frame.width
        let horizontalCenter = width / 2
        
        let page = Int(offSet + horizontalCenter) / Int(width)
        return page
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
        
        if let posts = userPosts, posts.count > 0 {
            if page == 0 {
                leftArea.isUserInteractionEnabled = false
                leftButtonOutlet.isEnabled = false
                if posts.count > 1 {
                    rightArea.isUserInteractionEnabled = true
                    rightButtonOutlet.isEnabled = true
                }
            }
            else if page > 0 && page < posts.count - 1 {
                leftArea.isUserInteractionEnabled = true
                rightArea.isUserInteractionEnabled = true
                leftButtonOutlet.isEnabled = true
                rightButtonOutlet.isEnabled = true
            }
            else if page == posts.count - 1 {
                rightArea.isUserInteractionEnabled = false
                rightButtonOutlet.isEnabled = false
                leftArea.isUserInteractionEnabled = true
                leftButtonOutlet.isEnabled = true
            }
        }
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
