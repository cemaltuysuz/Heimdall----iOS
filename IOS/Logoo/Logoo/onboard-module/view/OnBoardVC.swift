//
//  OnboardVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 20.01.2022.
//

import Foundation
import UIKit

class OnBoardVC : UIViewController {
    
    @IBOutlet weak var onBoardPageControl: UIPageControl!
    @IBOutlet weak var onBoardCollectionView: UICollectionView!
    
    var presenter:ViewToPresenterOnBoardProtocol?
    var onBoardList:[OnBoard]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onBoardList = [OnBoard]()
    
        OnBoardRouter.createModule(ref: self)
        presenter?.getOnBoardList()
        
        onBoardCollectionView.delegate = self
        onBoardCollectionView.dataSource = self
    }
    @IBAction func getStartButton(_ sender: Any) {
        performSegue(withIdentifier: "onBoardToLoginPref", sender: nil)
    }
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        onBoardCollectionView.scrollToItem(at: IndexPath(item: sender.currentPage, section: 0), at: .centeredHorizontally, animated: true)

    }
}

extension OnBoardVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onBoardList!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onBoardCollectionViewCell", for: indexPath) as! OnBoardCollectionCell
        let current = onBoardList![indexPath.row]
        
        cell.initializeCell(onBoard: current)

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: self.onBoardCollectionView.frame.width, height: self.onBoardCollectionView.frame.height)
        }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offSet = scrollView.contentOffset.x
            let width = scrollView.frame.width
            let horizontalCenter = width / 2

            let page = Int(offSet + horizontalCenter) / Int(width)
            self.onBoardPageControl.currentPage = page
        }
}

extension OnBoardVC : PresenterToViewOnBoardProtocol {
    func onBoardListToView(onBoardList: [OnBoard]) {
        DispatchQueue.main.async {
            self.onBoardList = onBoardList
            self.onBoardCollectionView.reloadData()
        }
    }
}
