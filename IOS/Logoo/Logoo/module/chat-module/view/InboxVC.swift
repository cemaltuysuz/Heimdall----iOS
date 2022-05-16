//
//  ChatVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 24.01.2022.
//

import UIKit
import Foundation

class InboxVC: BaseVC {
    
    @IBOutlet weak var userRequestView: UserRequestsView!
    var presenter:ViewToPresenterInboxProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InboxRouter.createModule(ref: self)
        presenter?.startConnection()
    }
    
}

// Tableview Refresh
extension InboxVC {
    
    func onRefreshInboxes(_ inboxes:[UserInbox]) {
        
    }
    
    func onRefreshRequests(_ requests:[RequestUser]) {
        DispatchQueue.main.async {
            print("geldi bisiler :\(requests.count)")
            self.userRequestView.updateRequests(requests)
        }
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
    case onRequestsChange(requests:[RequestUser])
    case onInboxesChange(inboxes:[UserInbox])
    case onError(error:InboxError)
}

enum InboxError : Error {}
