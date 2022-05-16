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
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var superScrollView: UIScrollView!
    @IBOutlet weak var pageIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var settingsBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var editProfileBarButtonItem: UIBarButtonItem!
    
    var user:User? {
        didSet {
            if let user = user {
                loadUser(user: user)
            }
        }
    }
    
    @IBOutlet weak var interestViewerHeightConstraint: NSLayoutConstraint!
    var presenter:ViewToPresenterProfileProtocol?
    var userUUID:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProfileRouter.createModule(ref: self)
        configureUI()
        loadPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadPage()
    }
    
    @IBAction func onClickSendMessageButton(_ sender: Any) {
        if let user = user, let hasSendMessagePermission = user.isAllowTheInboxInvite {
            if hasSendMessagePermission {
                // TODO: GO TO CHAT SCREEN
            }else {
                createBasicAlert(title: "Confirm".localized(),
                                 message: "This user does not allow direct messages. You can send a request.".localized(),
                                 okTitle: "Send", onCompletion: { type in
                    if type == .CONFIRM {
                        self.showCurtain()
                        self.presenter?.sendToRequest(self.userUUID)
                    }
                })
            }
        }
    }
    
    func configureUI(){
        let height = userInterestsViewer.interestsCollectionView.collectionViewLayout.collectionViewContentSize.height
        userInterestsViewer.heightAnchor.constraint(equalToConstant: height).activate(withIdentifier: "interestsHeightConstant")
        userManifestoTextView.heightAnchor.constraint(equalToConstant: 50).activate(withIdentifier: "userManifestoHeightConstraint")
        userInterestsViewer.delegate = self
        
        if userUUID != nil {
            settingsBarButtonItem.isEnabled = false
            editProfileBarButtonItem.isEnabled = false
            settingsBarButtonItem.tintColor = UIColor.clear
            editProfileBarButtonItem.tintColor = UIColor.clear
            
        }
    }
    
    func loadPage(){
        // if userUUD object is nil, interactor get account owner informations.
        // is userUUID object is not nil, interactor get spesific user informations.
        presenter?.loadPage(userUUID)
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
        closeCurtain()
        
        switch state {
        case .onUserLoad(let user):
            self.user = user
            break
        case .onPostsLoadSuccess(let posts):
            userPhotoSlider.updateUserPosts(posts: posts)
            break
        case .onProfileVisibleState(let type):
            updateVisibleState(type)
            break
            
        case .onPostsLoadFail:
            // TODO: Create fail page
            break
        case .onAlert(let title, let message):
            createAlertNotify(title: title, message: message)
            break
        }
    }
    
    func updateVisibleState(_ type:ProfileVisibleType) {
        
        switch type {
            
        case .visible:
            self.sendMessageButton.setImage(nil, for: .normal)
            break
            
        case .inVisible:
            let lockImage = UIImage(systemName: "lock")
            self.sendMessageButton.setImage(lockImage, for: .normal)
            break
            
        case .userVisible:
            let lockImage = UIImage(systemName: "lock.open")
            self.sendMessageButton.setImage(lockImage, for: .normal)
            break
        }
        
        self.sendMessageButton.isHidden = false
        
    }
    
    func loadUser(user:User) {
        DispatchQueue.main.async {
            
            if let url = user.userPhotoUrl {
                self.userPhotoImageView.setImage(urlString: url)
            }
            
            if let userBirth = user.userBirthDay?.toDate() {
                self.userAgeLabel.text = "\(Date().years(from: userBirth))"
            }
            
            self.userCountryLabel.text = user.userLiveCountry ?? "Turkey"
            
            if let gender = user.userGender {
                self.userGenderLabel.text = gender.localized()
            }
            
            self.userManifestoTextView.text = user.userManifesto
            
            if let interests = user.userInterests {
                self.userInterestsViewer.updateAndReloadData(interests: interests)
            }
            self.superScrollView.isHidden = false
            self.title = user.username
            self.pageIndicator.stopAnimating()
            print("loadUser is runned")
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
    case onProfileVisibleState(type:ProfileVisibleType)
    case onPostsLoadFail
    case onAlert(title:String, message:String)
}

enum ProfileVisibleType {
    case visible // profile is public
    case inVisible // this user can not see to the profile
    case userVisible // this user can see to the profile
}
