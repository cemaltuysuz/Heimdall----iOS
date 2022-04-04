//
//  LoginTransactionsVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.03.2022.
//

import UIKit

class LoginTransactionsVC: UIViewController {
    
    @IBOutlet weak var transactionsTableView: UITableView!
    var transactions:[UserTransaction]?
    var presenter : ViewToPresenterLoginTransactionsProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //createModule()
        configureUI()
        createModule()
    }
    
    func createModule(){
        LoginTransactionRouter.createModule(ref: self)
        presenter?.getLoginTransactions()
    }
    
    func configureUI(){
        transactionsTableView.delegate = self
        transactionsTableView.dataSource = self
        transactionsTableView.register(UINib(nibName: "LoginTransactionsCell", bundle: nil), forCellReuseIdentifier: "LoginTransactionsCell")
    }
}

extension LoginTransactionsVC : PresenterToViewLoginTransactionsProtocol {
    
    func transactionsToView(transactions: [UserTransaction]) {
        DispatchQueue.main.async {
            self.transactions = transactions
            self.transactionsTableView.reloadData()
        }
    }
}

extension LoginTransactionsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let current = transactions![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoginTransactionsCell") as! LoginTransactionsCell
        cell.configure(transaction: current)
        return cell
    }
}
