//
//  RegisterVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 20.01.2022.
//

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet weak var registerProgressView: UIProgressView!
    @IBOutlet weak var registerStepLabel: UILabel!
    @IBOutlet weak var registerCollectionView: UICollectionView!
    @IBOutlet weak var registerNextButton: UIButton!
    @IBOutlet weak var registerBackButton: UIButton!
    
    var validation:ValidationProtocol?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCollectionView.delegate = self
        registerCollectionView.dataSource = self
        
    }
    
    @IBAction func registerNextButton(_ sender: Any) {
       let current = findIndex(list: registerCollectionView)
        
        if current != 2 {
            registerCollectionView.scrollToNextItem()
            let response = validation?.validate()
            print(response!.message!)
        }else {
            performSegue(withIdentifier: "registerToHome", sender: nil)
        }
    }
    
    @IBAction func registerBackButton(_ sender: Any) {
        let current = findIndex(list: registerCollectionView)
        
        if current != 0 {
            registerCollectionView.scrollToPreviousItem()
        }
    }
}

extension RegisterVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.row)
        if indexPath.row == 0 {
            let photoPickCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoPickRegisterCell", for: indexPath) as! RegisterPhotoPickCell
            validation = photoPickCell
            return photoPickCell
        }
        else if indexPath.row == 1 {
            let informationCell = collectionView.dequeueReusableCell(withReuseIdentifier: "informationRegisterCell", for: indexPath) as! RegisterInformationCell
            validation = informationCell
            return informationCell
        }else {
            let otpCell = collectionView.dequeueReusableCell(withReuseIdentifier: "otpRegisterCell", for: indexPath) as! RegisterOTPCell
            validation = otpCell
            return otpCell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.registerCollectionView.frame.width, height: self.registerCollectionView.frame.height)
        }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offSet = scrollView.contentOffset.x
            let width = scrollView.frame.width
            let horizontalCenter = width / 2
            let page = Int(offSet + horizontalCenter) / Int(width)
            
        if page == 0 {
            self.registerProgressView.progress = 0.3
            self.registerStepLabel.text = "1/3"
            self.registerNextButton.setTitle("Devam", for: UIControl.State.normal)
            self.registerBackButton.isHidden = true
            
        }
        else if page == 1 {
            self.registerProgressView.progress = 0.6
            self.registerStepLabel.text = "2/3"
            self.registerNextButton.setTitle("Devam", for: UIControl.State.normal)
            self.registerBackButton.isHidden = false
        }
        else {
            self.registerProgressView.progress = 0.9
            self.registerStepLabel.text = "3/3"
            self.registerNextButton.setTitle("Onayla", for: UIControl.State.normal)
            self.registerBackButton.isHidden = false
        }
        }
    
    func findIndex(list:UICollectionView) -> Int{
        let asd = list.visibleCells
        if asd.last is RegisterPhotoPickCell {
            return 0
        }else if asd.last is RegisterInformationCell {
            return 1
        }
        else {
            return 2
        }
    }
}

extension UICollectionView {
    func scrollToNextItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }

    func scrollToPreviousItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }

    func moveToFrame(contentOffset : CGFloat) {
        self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
    }
}
