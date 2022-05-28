//
//  ChatVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 24.01.2022.
//

import UIKit
import Foundation

class InboxVC: BaseVC {
    
    @IBOutlet weak var pendingRequestStackView: UIStackView!
    @IBOutlet weak var userInboxesView: UserInboxesView!
    @IBOutlet weak var userRequestView: UserRequestsView!
    var presenter:ViewToPresenterInboxProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRegisterAndDelegate()
        
        InboxRouter.createModule(ref: self)
        presenter?.startConnection()
    }
    
    @IBAction func insertNewMessageButtonClick(_ sender: Any) {
        
    }
    
}

// Tableview Refresh
extension InboxVC {
    
    func onRefreshInboxes(_ inboxes:[VisibleInbox]) {
        
        DispatchQueue.main.async {
            self.userInboxesView.onUpdate(inboxes)
        }
        
    }
    
    func onRefreshRequests(_ requests:[Request]) {
        DispatchQueue.main.async {
            self.userRequestView.updateRequests(requests)
            let isHidden = requests.isEmpty
            
            UIView.animate(withDuration: 0.5, animations: {
                self.pendingRequestStackView.isHidden = isHidden
            })
        }
    }
    
    func setRegisterAndDelegate(){
        userRequestView.delegate = self
        userInboxesView.delegate = self
    }
}

extension InboxVC : UserRequestsViewProtocol {
    
    func onRequestClicked(_ request: Request) {
        
        let vc = RequestVC.instantiate(from: .Chat)
        vc.modalPresentationStyle = .popover
        vc.request = request
        vc.delegate = self
        present(vc,animated: true)
        
    }
    
}

extension InboxVC : RequestVCProtocol {
    
    func goProfile(_ userId: String) {
        let vc = ProfileVC.instantiate(from: .Profile)
        vc.userUUID = userId
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension InboxVC : UserInboxesViewProtocol {
    
    func inboxOnClick(_ connectionId: String) {
        let vc = ChatVC.instantiate(from: .Chat)
        vc.dualConnectionID = connectionId
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension InboxVC : PresenterToViewInboxProtocol {
    
    func onStateChange(state: InboxState) {
        
        switch state {
            
        case .onRequestsChange(let requests):
            onRefreshRequests(requests)
            break
            
        case .onInboxesChange(let inboxes):
            onRefreshInboxes(inboxes)
            break
            
        case .onError(let _):
            // TODO: Error handler
            break
        }
    }
    
}

enum InboxState {
    case onRequestsChange(requests:[Request])
    case onInboxesChange(inboxes:[VisibleInbox])
    case onError(error:InboxError)
}

enum InboxError : Error {}
