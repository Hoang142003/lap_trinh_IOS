//
//  EditViewController.swift
//  Project
//
//  Created by CNTT on 4/30/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import UIKit

class EditViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    //Properties
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var btnBill: UIButton!
    @IBOutlet weak var tfMoney: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var date: UIDatePicker!
    let optionCate=["Job","Breakfast"]
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBill.layer.cornerRadius=10
        tfMoney.layer.cornerRadius=10
        btnSave.layer.cornerRadius=10
        date.layer.cornerRadius=10
        date.backgroundColor=UIColor.white
        myTable.isHidden=true
        myTable.dataSource=self
        myTable.delegate=self
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTable.isHidden=true
        btnBill.setTitle(optionCate[indexPath.row], for: .normal)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionCate.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = tableView.dequeueReusableCell(withIdentifier: "CELL")
        item?.textLabel?.text=optionCate[indexPath.row]
        return item!
    }
    @IBAction func btnCate(_ sender: Any) {
        myTable.isHidden=false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
