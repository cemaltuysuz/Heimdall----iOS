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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}