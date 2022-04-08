//
//  LoginTransactionsCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 15.03.2022.
//

import UIKit

class LoginTransactionsCell: UITableViewCell {
    @IBOutlet weak var transactionTitleLabel: UILabel!
    @IBOutlet weak var transactionIconImageView: UIImageView!
    @IBOutlet weak var transactionDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(transaction:UserTransaction) {
        transactionIconImageView.tintColor = UIColor(named: "black700")
        if let system = transaction.systemInfo, let os = system.operatingSystem, let device = system.deviceModel, let image = transaction.getOSIcon() {
            transactionTitleLabel.text = "\(device) (\(os))"
            transactionIconImageView.image = image
        }
        transactionDateLabel.text = transaction.getTimeAsDate()?.toStringWithPattern(pattern: "dd-MMM-yyyy HH:mm")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
