//
//  DiscoveryTableViewCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 23.01.2022.
//

import UIKit

class DiscoveryTableViewCell: UITableViewCell {
    
    var hobbies:[String]?
    @IBOutlet weak var discoveryUserProfilePhotoImage: UIImageView!
    @IBOutlet weak var discoveryUsernameLabel: UILabel!
    @IBOutlet weak var discoveryUserHobbiesCollectionView: UICollectionView!
    
    func initialize(){
        hobbies = [String]()
    }
    
    func initialize(hobbyList:[String]){
        hobbies = hobbyList
        discoveryUserHobbiesCollectionView.delegate = self
        discoveryUserHobbiesCollectionView.dataSource = self
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
        return self.hobbies!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "discoveryCollectionCell", for: indexPath) as! DiscoveryCollectionViewCell
        cell.hobbyLabel.text = hobbies![indexPath.row]
        return cell
    }
    
    
}
