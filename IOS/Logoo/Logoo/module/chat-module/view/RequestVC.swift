//
//  RequestVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 16.05.2022.
//

import Foundation
import UIKit

protocol RequestVCProtocol : AnyObject {
    func goProfile(_ userId:String)
}


class RequestVC : BaseVC {
    
    var request:Request?
    @IBOutlet weak var reqTitleLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var goToProfileButtonOutlet: UIButton!
    @IBOutlet weak var redButtonOutlet: UIButton!
    @IBOutlet weak var pageIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pageContainer: UIView!
    @IBOutlet weak var confirmButtonOutlet: UIButton!
    
    weak var delegate:RequestVCProtocol?
    var presenter : ViewToPresenterRequestProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        RequestRouter.createModule(ref: self)
        if let request = request {
            presenter?.getTargetUserFromRequest(request)
        }
    }

    
    func initUI(){
        pageContainer.isHidden = true
        indicator.hidesWhenStopped = true
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    @IBAction func onClickConfirm(_ sender: Any) {
        if let request = request {
            presenter?.confirmRequest(request)
        }
    }
    
    @IBAction func onClickRedButton(_ sender: Any) {
        if let request = request {
            presenter?.rejectRequest(request)
        }
    }
    
    @IBAction func onClickGoToProfileButton(_ sender: Any) {
        
        dismiss(animated: true, completion: {
            
            if let sender = self.request?.senderId {
                self.delegate?.goProfile(sender)
            }
            
        })
        
    }
    
    func loadUser(user:User) {
        
        if request?.getRequestType() == .DIRECT_REQUEST {
            if let name = user.username {
                reqTitleLabel.text = "\(name) \("request_title".localized())"
            }
            
            if let photo = user.userPhotoUrl {
                userImageView.setImage(urlString: photo,
                                       radius: 10,
                                       focustStatus: false)
            }
        }
        pageContainer.isHidden = false
    }
}

extension RequestVC : PresenterToViewRequestProtocol {
    
    func onStateChange(state: RequestState) {

        switch state {
            
        case .onUserReceived(let user):
            
            loadUser(user: user)
            
            break
            
        case .error(let message):
            createAlertNotify(title: "Error".localized(),
                              message: message,
                              onCompletion: {
                
                self.dismiss(animated: true)
            })
            break
            
        case .changeResponseSucces:
            dismiss(animated: true)
            break
        }
        indicator.isHidden = true
    }
}

enum RequestState {
    case onUserReceived(user:User)
    case error(message:String)
    case changeResponseSucces
}
