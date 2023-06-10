//
//  SearchController.swift
//  Project
//
//  Created by CNTT on 4/26/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import UIKit

class SearchController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //Properties
    @IBOutlet weak var totalExpense: UILabel!
    @IBOutlet weak var totalIncome: UILabel!
    private var totalI:Double=0
    private var totalE:Double=0
    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var view1: UIButton!
    @IBOutlet weak var view2: UIButton!
    @IBOutlet weak var view3: UIButton!
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var tableDay: UITableView!
    @IBOutlet weak var tableCate: UITableView!
    @IBOutlet weak var btnDay: UIButton!
    @IBOutlet weak var btnCate: UIButton!
    private var cate_id:Int=0
    let optionDay=["All Day", "Choose day"]
    private var cateList=[Category]()
    private var dateList = [Dates]()
    let cate=Category(category_id: 0, category_name: "All Categories", category_loai: 0)
    private var categories:Category!
    private var dates:Dates!
    private var history=[History]()
    private var dao:Database_layer!
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.backgroundColor=UIColor.white
        view1.layer.cornerRadius=10
        view2.layer.cornerRadius=10
        view3.layer.cornerRadius=10
        myTable.dataSource=self
        myTable.delegate=self
        tableDay.dataSource=self
        tableDay.delegate=self
        tableCate.dataSource=self
        tableCate.delegate=self
        myTable.layer.cornerRadius=10
        tableDay.isHidden=true
        tableCate.isHidden=true
        picker.isHidden=true
        //Khoi tao doi tuong database
        dao=Database_layer()
        cateList.append(cate)
        dao.getAllCate(categories: &cateList)
        dao.getAllDate(dates: &dateList)
        dates=Dates(date_id: 1, date: Date(), money: 1, wallet: 1)
        categories=Category(category_id: 1, category_name: "a", category_loai: 1)
        totalIncome.text="0 VND"
        totalExpense.text="0 VND"
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item1=tableView.dequeueReusableCell(withIdentifier: "CELL")
        
        if tableView.tag==0{
            let item=tableView.dequeueReusableCell(withIdentifier: "CELL") as! SearchTableViewCell
            if !history.isEmpty{
            dao.getCategory(cate_id: history[indexPath.row].getCateID(), categories: &categories)
            dao.getDate(date_id: history[indexPath.row].getDateID(), dates: &dates)
            let dateFormatter=DateFormatter()
            dateFormatter.dateFormat="dd/MM/yyyy"
            let date=dateFormatter.string(from: dates.getDate())
            item.imgSearch.image=UIImage(named: categories.getCateName().lowercased())
                item.nameSearch.text=categories.getCateName()
                item.daySearch.text=date
            if history[indexPath.row].getTransactionMoney()<0{
                item.moneySearch.textColor=UIColor.red
            }
            else{
                item.moneySearch.textColor=UIColor.green
            }
            if history[indexPath.row].getTransactionMoney().getDecimal() == 0{
                item.moneySearch.text = String(format: "%0.0f",history[indexPath.row].getTransactionMoney())+" VND"
            }
            else{
                item.moneySearch.text=String(history[indexPath.row].getTransactionMoney())+" VND"
            }
            
            return item
            }
        }
        else if tableView.tag==1{
            item1?.textLabel?.text=optionDay[indexPath.row]
        }
        else if tableView.tag==2{
            item1?.textLabel?.text=cateList[indexPath.row].getCateName()
        }
        return item1!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag==0{
            if !history.isEmpty{
            return history.count
            }
        }
        else if tableView.tag==1{
            return optionDay.count
        }
        else if tableView.tag==2{
            return cateList.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag==0{
            let edit=storyboard?.instantiateViewController(withIdentifier: "EditScreen")as!EditViewController
            edit.history=history[indexPath.row]
            self.navigationController?.pushViewController(edit, animated: true)
        }
        else if tableView.tag==1{
            tableDay.isHidden=true
            btnDay.setTitle(optionDay[indexPath.row], for: .normal  )
            if optionDay[indexPath.row] == "Choose day"{
                picker.isHidden=false
            }
            else{
                picker.isHidden=true
            }
        }
        else if tableView.tag==2{
            tableCate.isHidden=true
            btnCate.setTitle(cateList[indexPath.row].getCateName(), for: .normal  )
            cate_id=cateList[indexPath.row].getCateID()
        }
        
    }
    @IBAction func btnDay(_ sender: UIButton) {
        tableDay.isHidden=false
    }
    @IBAction func btnCate(_ sender: UIButton) {
        tableCate.isHidden=false
    }
    @IBAction func btnSave(_ sender: UIButton) {
        if btnDay.titleLabel?.text == "All Day"{
            totalI=0
            totalE=0
            history.removeAll()
            dao.SearchCate(cate_id: cate_id, history: &history)
            myTable.reloadData()
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
        else{
            let dateFormatter=DateFormatter()
            dateFormatter.dateFormat="dd/MM/yyyy"
            totalI=0
            totalE=0
            history.removeAll()
            var his=[History]()
            dao.getAllHistory(history: &his)
            let date=picker.date
            for d in dateList{
                if dateFormatter.string(from: d.getDate())==dateFormatter.string(from: date)
                {
                    for h in his{
                        if h.getDateID()==d.getDateID(){
                            if cate_id==0
                            {
                            history.append(h)
                            }
                            else{
                                if h.getCateID()==cate_id{
                                    history.append(h)
                                }
                            }
                        }
                    }
                }
            }
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
            //dao.SearchDay(daySeek: date, cate_id: cate_id, history: &history)
            myTable.reloadData()
        }
    }
}
