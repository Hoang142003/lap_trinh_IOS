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
    public var date_id:Int!
    private var dao:Database_layer!
    private var history=[History]()
    private var categories:Category!
    private var dates:Dates!
    @IBOutlet weak var dateView: UILabel!
    @IBOutlet weak var totalIncome: UILabel!
    @IBOutlet weak var totalExpense: UILabel!
    private var totalI:Double=0
    private var totalE:Double=0
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.dataSource=self
        myTable.delegate=self
        myTable.layer.cornerRadius=10
        //khoi tao database
        dao=Database_layer()
        dao.getHistory(date_id:date_id, history: &history)
        dates=Dates(date_id: 1, date: Date(), money: 1, wallet: 1)
        categories=Category(category_id: 1, category_name: "a", category_loai: 1)
        dao.getDate(date_id: date_id, dates: &dates!)
        
        let dateFormatter=DateFormatter()
        dateFormatter.dateFormat="dd/MM/yyyy"
        let date=dateFormatter.string(from: dates.getDate())
        dateView.text=date
        for history in history{
            if history.getTransactionMoney()<0{
                totalE += history.getTransactionMoney()
            }
            else{
                totalI += history.getTransactionMoney()
            }
            if totalI.getDecimal() == 0{
                totalIncome.text = String(format: "%0.0f",totalI)+" VND"
            }
            else{
                totalIncome.text=String(totalI)+" VND"
            }
            if totalE.getDecimal() == 0{
                totalExpense.text = String(format: "%0.0f",totalE)+" VND"
            }
            else{
                totalExpense.text=String(totalE)+" VND"
            }
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item=tableView.dequeueReusableCell(withIdentifier: "CELL") as! DetailTableViewCell
        dao.getCategory(cate_id: history[indexPath.row].getCateID(), categories: &categories)
        item.imgDetail.image=UIImage(named: categories.getCateName().lowercased())
        item.nameDetail.text=categories.getCateName()
        item.moneyDetail.text=String(history[indexPath.row].getTransactionMoney())
        if history[indexPath.row].getTransactionMoney()<0{
            item.moneyDetail.textColor=UIColor.red
        }
        else{
            item.moneyDetail.textColor=UIColor.green
        }
        if history[indexPath.row].getTransactionMoney().getDecimal() == 0{
            item.moneyDetail.text = String(format: "%0.0f",history[indexPath.row].getTransactionMoney())+" VND"
        }
        else{
            item.moneyDetail.text=String(history[indexPath.row].getTransactionMoney())+" VND"
        }
        
        return item
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let edit=storyboard?.instantiateViewController(withIdentifier: "EditScreen")as!EditViewController
        edit.history=history[indexPath.row]
        self.navigationController?.pushViewController(edit, animated: true)
    }
    
}
