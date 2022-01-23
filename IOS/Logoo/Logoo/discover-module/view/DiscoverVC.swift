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
        
        let navigationItem = self.tabBarController?.navigationItem.titleView
        let segmentedControl = navigationItem as! UISegmentedControl
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
    }
    
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        self.tabBarController?.selectedIndex = sender.selectedSegmentIndex
    }
}

extension DiscoverVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
