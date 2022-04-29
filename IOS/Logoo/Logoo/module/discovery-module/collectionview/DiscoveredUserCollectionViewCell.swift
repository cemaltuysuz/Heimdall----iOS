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
    
    @IBOutlet weak var userProfilePhotoImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    weak var delegate:DiscoveredUserCollectionViewCellProtocol?
    
    var user:User?
    
    override func awakeFromNib() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.onContentClick(_:)))
        contentView.isUserInteractionEnabled = true
        contentView.addGestureRecognizer(recognizer)
    }
    
    func configureUI(){
        let cellWidth = userProfilePhotoImageView.frame.width
        userProfilePhotoImageView.forceUpdateConstraint(constant: cellWidth,
                                                        attribute: .height)
        
        usernameLabel.forceUpdateConstraint(constant: cellWidth,
                                            attribute: .width)
    }

    func initialize(_ user:User){
        self.user = user
        if let name = user.username {
            usernameLabel.text = name
        }
        userProfilePhotoImageView.setImage(urlString: user.userPhotoUrl,
                                           radius: 10,
                                           focustStatus: false)
        configureUI()
    }
}

extension DiscoveredUserCollectionViewCell {
    @objc
    func onContentClick(_ recognizer:UITapGestureRecognizer){
        guard let user = user else {return}
        delegate?.onUserClick(user)
    }
}
