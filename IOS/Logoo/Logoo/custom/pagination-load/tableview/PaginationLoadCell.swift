//
//  PaginationLoadCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 23.04.2022.
//

import UIKit

class PaginationLoadCell: UITableViewCell {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    func startAnimating(){
        indicator.startAnimating()
    }
    
}
