//
//  DiscoverVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 22.01.2022.
//

import UIKit

class DiscoverVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let asd = self.tabBarController?.navigationItem.titleView
        let segmentedControl = asd as! UISegmentedControl
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
    }
    
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.tabBarController?.selectedIndex = 0
        }
        else if sender.selectedSegmentIndex == 1 {
            self.tabBarController?.selectedIndex = 1
        }
    }
}
