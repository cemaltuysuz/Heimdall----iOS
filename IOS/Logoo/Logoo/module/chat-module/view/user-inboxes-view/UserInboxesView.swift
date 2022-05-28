//
//  UserInboxesView.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.05.2022.
//

import Foundation
import UIKit

protocol UserInboxesViewProtocol : AnyObject {
    
}

class UserInboxesView : NibLoadableView {
    
    @IBOutlet weak var inboxTableView: UITableView!
    @IBOutlet weak var tableIndicator: UIActivityIndicatorView!
    
    var inboxes:[VisibleInbox]?
    
    weak var delegate:UserInboxesViewProtocol?
    
    override func awakeFromNib() {
        inboxTableView.isHidden = true
        tableIndicator.hidesWhenStopped = true
        tableIndicator.startAnimating()
        setRegisters()
    }
    
    func setRegisters() {
        inboxTableView.delegate = self
        inboxTableView.dataSource = self
        inboxTableView.register(InboxCell.self)
        inboxTableView.rowHeight = 95
    }
    
    func onUpdate(_ inboxes:[VisibleInbox]) {
        
        DispatchQueue.main.async {
            self.inboxes = inboxes
            self.inboxTableView.reloadData()
            self.tableIndicator.isHidden = true
            self.inboxTableView.isHidden = false
        }
        
    }
    
}

extension UserInboxesView : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inboxes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let current = inboxes![indexPath.row]
        
        let cell = tableView.dequeue(indexPath, type: InboxCell.self)
        cell.setUp(current)
        
        return cell
    }
    
    
}
