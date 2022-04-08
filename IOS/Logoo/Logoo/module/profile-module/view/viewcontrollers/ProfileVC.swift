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
        title = "Logoo"
    }
    
    func loadPage(){
        presenter?.loadPage()
    }
}

extension ProfileVC : PresenterToViewProfileProtocol {
    func onStateChange(state: ProfileState) {
        switch state {
        case .onUserLoad(let user):
            if let url = user.userPhotoUrl {
                userPhotoImageView.setImage(urlString: url)
                title = user.username
                userManifestoTextView.text = user.userManifesto
                
                if let interests = user.userInterests?.toListByCharacter(GeneralSeperators.INTEREST_SEPERATOR) {
                    userInterestsViewer.updateAndReloadData(interests: interests)
                }
                
            }
        case .onPostsLoadSuccess(let posts):
            userPhotoSlider.updateUserPosts(posts: posts)
        case .onPostsLoadFail:
            // TODO: Create fail page
            break
        case .onError(let message):
            createAlertNotify(title: "Error".localized(), message: message, onCompletion: {})
        }
    }
}


enum ProfileState {
    case onUserLoad(user:User)
    case onPostsLoadSuccess(posts:[UserPost])
    case onPostsLoadFail
    case onError(message:String)
}
