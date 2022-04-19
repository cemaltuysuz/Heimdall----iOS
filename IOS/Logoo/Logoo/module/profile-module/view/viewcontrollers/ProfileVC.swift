//
//  ProfileVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 1.03.2022.
//

import UIKit

class ProfileVC: BaseVC {

    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var userManifestoTextView: UITextView!
    @IBOutlet weak var userPhotoSlider: LGPhotoSlider!
    @IBOutlet weak var userInterestsViewer: InterestsViewer!
    
    @IBOutlet weak var userAgeLabel: UILabel!
    @IBOutlet weak var userCountryLabel: UILabel!
    @IBOutlet weak var userGenderLabel: UILabel!
    
    
    @IBOutlet weak var interestViewerHeightConstraint: NSLayoutConstraint!
    
    
    var presenter:ViewToPresenterProfileProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        ProfileRouter.createModule(ref: self)
        configureUI()
        loadPage()
    }
    override func viewWillAppear(_ animated: Bool) {
        presenter?.loadPage()
    }
    
    func configureUI(){
        let height = userInterestsViewer.interestsCollectionView.collectionViewLayout.collectionViewContentSize.height
        userInterestsViewer.heightAnchor.constraint(equalToConstant: height).activate(withIdentifier: "interestsHeightConstant")
        userManifestoTextView.heightAnchor.constraint(equalToConstant: 50).activate(withIdentifier: "userManifestoHeightConstraint")
    }
    
    func loadPage(){
        userInterestsViewer.delegate = self
        presenter?.loadPage()
    }
    
    func updateUserManifesto(text:String) {
        if !text.isEmpty, text != userManifestoTextView.text {
            if let constraint = userManifestoTextView.getConstraint(withIndentifier: "userManifestoHeightConstraint") {
                constraint.constant = userManifestoTextView.contentSize.height
            }
        }
    }
    
    @IBAction func onSettingsBarButtonItemClick(_ sender: Any) {
        let vc = SettingsVC.instantiate(from: .Settings)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onEditProfileBarButtonItemClick(_ sender: Any) {
        let vc = EditProfileVC.instantiate(from: .Profile)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension ProfileVC : PresenterToViewProfileProtocol {
    func onStateChange(state: ProfileState) {
        switch state {
        case .onUserLoad(let user):
            loadUser(user: user)
        case .onPostsLoadSuccess(let posts):
            userPhotoSlider.updateUserPosts(posts: posts)
        case .onPostsLoadFail:
            // TODO: Create fail page
            break
        case .onError(let message):
            createAlertNotify(title: "Error".localized(), message: message)
        }
    }
    
    func loadUser(user:User) {
        DispatchQueue.main.async {
            
            if let url = user.userPhotoUrl {
                self.userPhotoImageView.setImage(urlString: url)
                self.title = user.username
            }
            
            if let userBirth = user.userBirthDay?.toDate() {
                self.userAgeLabel.text = "\(Date().years(from: userBirth))"
            }
            
            self.userCountryLabel.text = user.userLiveCountry ?? "Turkey"
            
            if let gender = user.userGender {
                self.userGenderLabel.text = gender.localized()
            }
            
            self.userManifestoTextView.text = user.userManifesto
            
            if let interests = user.userInterests?.toListByCharacter(GeneralConstant.INTEREST_SEPERATOR) {
                self.userInterestsViewer.updateAndReloadData(interests: interests)
            }
            
            
        }
    }
}

extension ProfileVC : InterestsViewerProtocol {
    func onContentUpdated(_ collectionView: UICollectionView) {
        DispatchQueue.main.async {
            let height:CGFloat = collectionView.collectionViewLayout.collectionViewContentSize.height
            if let filteredConstraint = self.userInterestsViewer.getConstraint(withIndentifier: "interestsHeightConstant") {
                filteredConstraint.constant = height
            }
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
}


enum ProfileState {
    case onUserLoad(user:User)
    case onPostsLoadSuccess(posts:[UserPost])
    case onPostsLoadFail
    case onError(message:String)
}
