//
//  InboxCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.05.2022.
//

import UIKit

class InboxCell: UITableViewCell {
    
    @IBOutlet weak var inboxImageView: UIImageView! // target userPhoto
    @IBOutlet weak var inboxTitleLabel: UILabel! // target username
    @IBOutlet weak var inboxDescriptionLabel: UITextView! // last message
    
    func setUp(_ inbox:VisibleInbox) {
        inboxImageView.setImage(urlString: inbox.inboxPhotoURL,
                                radius: 10,
                                focustStatus: true)
        
        inboxTitleLabel.text = inbox.inboxTitle
        let hand = "👋"
        inboxDescriptionLabel.text = inbox.inboxLastMessage.isEmpty ? "\(inbox.inboxTitle ?? "") icin el salla \(hand)" : inbox.inboxLastMessage
    }
    
}
