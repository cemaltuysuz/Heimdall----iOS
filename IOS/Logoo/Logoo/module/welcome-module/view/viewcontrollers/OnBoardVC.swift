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
    @IBOutlet weak var letStartButtonOutlet: UIButton!
    
    var presenter:ViewToPresenterOnBoardProtocol?
    var onBoardList:[OnBoard]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureBinds()
        
        OnBoardRouter.createModule(ref: self)
        presenter?.getOnBoardList()
    }
    
    func configureUI(){
        letStartButtonOutlet.setTitle("Let's Start !".localized(), for: .normal)
    }
    
    func configureBinds(){
        onBoardCollectionView.delegate = self
        onBoardCollectionView.dataSource = self
    }
    
    /**
     It directs the user to the Login Pref VC screen to select the login method.
     */
    @IBAction func getStartButton(_ sender: Any) {
        UDService.shared.changeOnboardVisibilityInfo(value: true)

        let vc = LoginPrefVC.instantiate(from: .Welcome)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        onBoardCollectionView.scrollToItem(at: IndexPath(item: sender.currentPage, section: 0), at: .centeredHorizontally, animated: true)

    }
}

extension OnBoardVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onBoardList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath, type: OnBoardCollectionCell.self)
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
