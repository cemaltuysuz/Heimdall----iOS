//
//  UserView.swift
//  Logoo
//
//  Created by cemal tüysüz on 24.04.2022.
//

import Foundation
import UIKit
import ImageViewer_swift

class UserView : NibLoadableView {
    
   // @IBOutlet weak var interestsViewer: InterestsViewer!
    @IBOutlet weak var viewContainer: UIView!
    //@IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var userAgeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var userManifesto: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        configureUI()
    }
    
    private func configureUI(){
        viewContainer.isHidden = true
        //loadIndicator.hidesWhenStopped = true
        //loadIndicator.startAnimating()
        //interestsViewer.delegate = self
    }
}

extension UserView {
    func loadUserToView(_ user: User) {
        DispatchQueue.main.async {
            self.userPhotoImageView.setImage(urlString: user.userPhotoUrl,
                                             radius: 10,
                                             focustStatus: true)
            if let name = user.username {
                self.usernameLabel.text = name
            }
            
            if let birthDay = user.userBirthDay, let date = birthDay.toDate(){
                self.userAgeLabel.text = "\(Date().years(from: date))"
            }
            
            if let location = user.userLiveCountry {
                self.locationLabel.text = location
            }
            
            if let gender = user.userGender, let type = GenderType(rawValue: gender) {
                self.genderLabel.text = type.rawValue.localized
            }
            if let interests = user.userInterests, !interests.isEmpty {
                //self.interestsViewer.updateAndReloadData(interests: interests)
            }
           // self.loadIndicator.stopAnimating()
            self.viewContainer.isHidden = false
        }
    }
}

extension UserView : InterestsViewerProtocol {
    func onContentUpdated(_ collectionView: UICollectionView) {
        DispatchQueue.main.async {
            let height:CGFloat = collectionView.collectionViewLayout.collectionViewContentSize.height

            //self.interestsViewer.forceUpdateConstraint(constant: height, attribute: .height)
            UIView.animate(withDuration: 0.5) {
                self.layoutIfNeeded()
            }
        }
    }
}

