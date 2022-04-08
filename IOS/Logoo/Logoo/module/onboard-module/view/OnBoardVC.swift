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
    /**
     It directs the user to the Login Pref VC screen to select the login method.
     */
    @IBAction func getStartButton(_ sender: Any) {
        UDService.shared.changeOnboardVisibilityInfo(value: true)
        performSegue(withIdentifier: OnBoardVCSegues
                        .onBoardToLoginPref
                        .rawValue
                     , sender: nil)
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
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: OnBoardCollectionViewCell
                .onBoardCell
                .rawValue, for: indexPath) as! OnBoardCollectionCell
        let current = onBoardList![indexPath.row]
        
        cell.initializeCell(onBoard: current)

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: self.onBoardCollectionView.frame.width, height: self.onBoardCollectionView.frame.height)
        }
    /**
     A function to understand which page the user is on and to update the UI .
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offSet = scrollView.contentOffset.x
            let width = scrollView.frame.width
            let horizontalCenter = width / 2

            let page = Int(offSet + horizontalCenter) / Int(width)
            onBoardPageControl.currentPage = page
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

enum OnBoardVCSegues :String {
    case onBoardToLoginPref = "onBoardToLoginPref"
}

enum OnBoardCollectionViewCell : String {
    case onBoardCell = "onBoardCollectionViewCell"
}
