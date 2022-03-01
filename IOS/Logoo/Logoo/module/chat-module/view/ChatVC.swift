//
//  ChatVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 24.01.2022.
//

import UIKit
import Foundation


class ChatVC: UIViewController {
    
    @IBOutlet weak var waitingRequestsCollectionView: UICollectionView!
    @IBOutlet weak var inboxCollectionView: UICollectionView!
        
    var chatList:[Any]?
  //  var requestList:[ChatRequest]?
    
  //  var presenter:ViewToPresenterChatProtocol?//

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatList = [Any]()
    //    requestList = [ChatRequest]()
        
/*
 inboxCollectionView.delegate = self
 inboxCollectionView.dataSource = self
 
 waitingRequestsCollectionView.delegate = self
 waitingRequestsCollectionView.dataSource = self

 ChatRouter.createModule(ref: self)
 presenter?.getAllRequirements()
 **/
    }
}


/**
 extension ChatVC : PresenterToViewChatProtocol {
     func chatsToView(chats: [Any]) {
         DispatchQueue.main.async {
             
             self.chatList = chats
             self.inboxCollectionView.reloadData()
         }
     }
     
     func requestsToView(requests: [ChatRequest]) {
         DispatchQueue.main.async {
             self.requestList = requests
             self.waitingRequestsCollectionView.reloadData()
             print("requestler geldi \(requests.count)")
         }
     }
 }
 */

/**
 extension ChatVC : UICollectionViewDelegate, UICollectionViewDataSource {
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         if collectionView == self.inboxCollectionView {
             return 0
         }
         return 0
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
         if collectionView == self.inboxCollectionView {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "inboxCollectionViewCell", for: indexPath) as! InboxCollectionViewCell
             let currentItem = chatList![indexPath.row]
             if(currentItem is Any) {
                 let item = currentItem as! Room
                 cell.inboxTitleLabel.text = item.roomTitle!
                 cell.inboxImageView.layer.masksToBounds = true
                 cell.inboxImageView.layer.cornerRadius = cell.inboxImageView.bounds.width / 2
             }else {
                 let item = currentItem as! Any
                 cell.inboxTitleLabel.text = item.p2pMembers![1].username!
                 cell.inboxImageView.layer.masksToBounds = true
                 cell.inboxImageView.layer.cornerRadius = 10
             }
             
             return cell
         }else {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "waitingCollectionViewCell", for: indexPath) as! WaitingRequestCollectionViewCell
             
             let item = requestList![indexPath.row]
             
             if item.requestType == .ROOM_REQUEST {
                 cell.waitingRequestImage.layer.masksToBounds = true
                 cell.waitingRequestImage.layer.cornerRadius = cell.waitingRequestImage.bounds.width / 2
                 cell.waitingRequestTitle.text = item.requestSenderId!
             }else {
                 cell.waitingRequestImage.layer.masksToBounds = true
                 cell.waitingRequestImage.layer.cornerRadius = 10
                 cell.waitingRequestTitle.text = item.requestSenderId!
             }
             
             return cell
         }
     }
     
     
 }
 
 */
