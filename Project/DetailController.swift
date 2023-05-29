//
//  DetailController.swift
//  Project
//
//  Created by CNTT on 4/29/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import UIKit

class DetailController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    //Properties
    @IBOutlet weak var myTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.dataSource=self
        myTable.delegate=self
        myTable.layer.cornerRadius=10
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item=tableView.dequeueReusableCell(withIdentifier: "CELL") as! DetailTableViewCell
        if indexPath.row == 0{
            item.imgDetail.image=UIImage(named: "bill")
            item.nameDetail.text="Bill"
            item.moneyDetail.text="20000 VND"
        }
        else{
            item.imgDetail.image=UIImage(named: "salary")
            item.nameDetail.text="Salary"
            item.moneyDetail.text="30000 VND"
            item.moneyDetail.textColor=UIColor.green
        }
        return item
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let edit=storyboard?.instantiateViewController(withIdentifier: "EditScreen")as!EditViewController
        self.navigationController?.pushViewController(edit, animated: true)
    }
    
}
