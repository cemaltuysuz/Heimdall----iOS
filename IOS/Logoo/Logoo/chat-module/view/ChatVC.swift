//
//  ChatVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 24.01.2022.
//

import UIKit

class ChatVC: UIViewController {
    
    var presenter:ViewToPresenterChatProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        ChatRouter.createModule(ref: self)
    }
}

extension ChatVC : PresenterToViewChatProtocol {
    
    func roomChatsToView(room: [Room]) {
        <#code#>
    }
    
    func p2pChatsToView(p2p: [P2P]) {
        <#code#>
    }
}
