//
//  DiscoveredUserCollectionViewCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 26.04.2022.
//

import UIKit

protocol DiscoveredUserCollectionViewCellProtocol : AnyObject {
    func onUserClick(_ user:User)
}

class DiscoveredUserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var manifestoTextView: UITextView!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var userAgeLabel: UILabel!
    @IBOutlet weak var userCountryLabel: UILabel!
    @IBOutlet weak var userGenderLabel: UILabel!
    
    weak var delegate:DiscoveredUserCollectionViewCellProtocol?
    
    var user:User?
    
    override func awakeFromNib() {
        configureUI()
    }
    
    func configureUI(){
        sendMessageButton.addTarget(self, action: #selector(self.onContentClick), for: .touchUpInside)
    }

    func initialize(_ user:User){
        self.user = user
        
        userImageView.setImage(urlString: user.userPhotoUrl,
                               radius: 10,
                               focustStatus: true)
        
        if let name = user.username {
            usernameLabel.text = name
        }
        
        if let manifesto = user.userManifesto, !manifesto.isEmpty {
            manifestoTextView.text = manifesto
        }else {
            manifestoTextView.isHidden = true
        }
        
        if let birthDay = user.userBirthDay, !birthDay.isEmpty, let date = birthDay.toDate() {
            userAgeLabel.text = "\(Date().years(from: date))"
        }else {
            userAgeLabel.text = "-"
        }
        
        if let country = user.userLiveCountry, !country.isEmpty {
            userCountryLabel.text = country
        }else {
            userCountryLabel.text = "-"
        }
        
        if let gender = user.userGender, let genderType = GenderType(rawValue: gender) {
            userGenderLabel.text = genderType.rawValue.localized()
        }else {
            userGenderLabel.text = ""
        }
    }
}

extension DiscoveredUserCollectionViewCell {
    @objc
    func onContentClick(){
        guard let user = user else {return}
        delegate?.onUserClick(user)
    }
}
