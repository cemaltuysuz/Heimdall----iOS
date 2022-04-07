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
    
    
    var presenter:ViewToPresenterProfileProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        ProfileRouter.createModule(ref: self)
        configureUI()
        loadPage()
    }
    @IBAction func insertPhotoButton(_ sender: Any) {
        
    }
    
    func configureUI(){
        userPhotoSlider.configure()
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
