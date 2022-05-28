//
//  ChatVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 28.05.2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView


class ChatVC: MessagesViewController {
    
    var dualConnectionID:String?
    var presenter:ViewToPresenterChatProtocol?
    var messages:[MessageLocal]?
    var sender:CurrentMessager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        setRegisterAndDelegate()
        
        ChatRouter.createModule(ref: self)
        
        if let dualConnectionID = dualConnectionID {
            presenter?.connectMessages(dualConnectionID)
        }
        
    }
    
    func setRegisterAndDelegate() {
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
}

extension ChatVC : PresenterToViewChatProtocol {
    func onStateChange(state: ChatState) {
        
        switch state {
        case .onMessagesUpdated(let messages, let sender):
            DispatchQueue.main.async {
                self.navigationController?.title = sender.displayName
                self.sender = sender as? CurrentMessager
                self.messages = messages
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem()
            }
            break
        case .onMessageSendSucces:
            messageInputBar.inputTextView.text = ""
            break
        }
    }
}

extension ChatVC : InputBarAccessoryViewDelegate, MessagesDisplayDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        presenter?.sendMessage(text)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        var photoUrl:String?
        
        if message.sender is CurrentMessager {
            photoUrl = (message.sender as! CurrentMessager).photoUrl
        }else {
            photoUrl = (message.sender as! OtherMessager).photoUrl
        }
        avatarView.setImage(urlString: photoUrl, radius: nil, focustStatus: false)
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        var corners: UIRectCorner = []
        
        if isFromCurrentSender(message: message) {
            corners.formUnion(.topLeft)
            corners.formUnion(.bottomLeft)
            if !isPreviousMessageSameSender(at: indexPath) {
                corners.formUnion(.topRight)
            }
            if !isNextMessageSameSender(at: indexPath) {
                corners.formUnion(.bottomRight)
            }
        } else {
            corners.formUnion(.topRight)
            corners.formUnion(.bottomRight)
            if !isPreviousMessageSameSender(at: indexPath) {
                corners.formUnion(.topLeft)
            }
            if !isNextMessageSameSender(at: indexPath) {
                corners.formUnion(.bottomLeft)
            }
        }
        
        return .custom { view in
            let radius: CGFloat = 16
            let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            view.layer.mask = mask
        }
    }
    
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return messages![indexPath.section].sender.senderId == messages![indexPath.section - 1].sender.senderId
    }
    
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < messages!.count else { return false }
        return messages![indexPath.section].sender.senderId == messages![indexPath.section + 1].sender.senderId
    }
    
    func isTimeLabelVisible(at indexPath: IndexPath) -> Bool {
        return indexPath.section % 3 == 0 && !isPreviousMessageSameSender(at: indexPath)
    }
}

extension ChatVC : MessagesDataSource, MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isTimeLabelVisible(at: indexPath) {
            return 18
        }
        return 0
    }
    
    func currentSender() -> SenderType {
        return sender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages![indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages?.count ?? 0
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if isTimeLabelVisible(at: indexPath) {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if !isPreviousMessageSameSender(at: indexPath) {
            let name = message.sender.displayName
            return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
        }
        return nil
    }

    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {

        if !isNextMessageSameSender(at: indexPath) && isFromCurrentSender(message: message) {
            return NSAttributedString(string: "Delivered", attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
        }
        return nil
    }
}
// configure
extension ChatVC {
    
    func initUI(){
        configureMessageInputBar()
    }
    
    func configureMessageInputBar() {
        //super.configureMessageInputBar()
        
        messageInputBar.inputTextView.tintColor = Color.black700!
        messageInputBar.sendButton.setTitleColor(Color.black700!, for: .normal)
        messageInputBar.sendButton.setTitleColor(
            Color.black700!.withAlphaComponent(0.3),
            for: .highlighted)
        
        
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.tintColor = Color.black700!
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        messageInputBar.inputTextView.layer.borderColor = Color.gray500?.cgColor
        messageInputBar.inputTextView.layer.borderWidth = 1.0
        messageInputBar.inputTextView.layer.cornerRadius = 16.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
}

enum ChatState {
    case onMessagesUpdated(messages:[MessageLocal], sender:SenderType)
    case onMessageSendSucces
}


