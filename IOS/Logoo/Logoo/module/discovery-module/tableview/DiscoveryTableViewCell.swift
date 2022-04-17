//
//  DiscoveryTableViewCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 23.01.2022.
//

import UIKit
import Kingfisher

class DiscoveryTableViewCell: UITableViewCell {
    
    var hobbies:[String]?
    @IBOutlet weak var discoveryUserProfilePhotoImage: UIImageView!
    @IBOutlet weak var discoveryUsernameLabel: UILabel!
    @IBOutlet weak var discoveryUserHobbiesCollectionView: UICollectionView!
    
    func initialize(user:User){
        if let interests = user.userInterests, !interests.isEmpty {
            hobbies = interests.toListByCharacter(GeneralConstant.INTEREST_SEPERATOR)
            discoveryUserHobbiesCollectionView.delegate = self
            discoveryUserHobbiesCollectionView.dataSource = self
        }
        discoveryUserProfilePhotoImage.kf.setImage(with: URL(string: user.userPhotoUrl!))
        discoveryUsernameLabel.text = user.username!
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

extension DiscoveryTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hobbies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "discoveryCollectionCell", for: indexPath) as! DiscoveryCollectionViewCell
        cell.hobbyLabel.text = hobbies![indexPath.row]
        return cell
    }
}
