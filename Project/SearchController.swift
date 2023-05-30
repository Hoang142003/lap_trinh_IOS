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
    @IBOutlet weak var view1: UIButton!
    @IBOutlet weak var view2: UIButton!
    @IBOutlet weak var view3: UIButton!
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var tableDay: UITableView!
    @IBOutlet weak var tableCate: UITableView!
    @IBOutlet weak var btnDay: UIButton!
    @IBOutlet weak var btnCate: UIButton!
    let optionDay=["This month","This week"]
    var cateList=[Category]()
    private var dao:Database_layer!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        //Khoi tao doi tuong database
        dao=Database_layer()
        dao.getAllCate(categories: &cateList)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item1=tableView.dequeueReusableCell(withIdentifier: "CELL")
        if tableView.tag==0{
            let item=tableView.dequeueReusableCell(withIdentifier: "CELL") as! SearchTableViewCell
            if indexPath.row==0{
                item.imgSearch.image=UIImage(named: "bill")
                item.nameSearch.text="Bill"
                item.daySearch.text="26/04/2023"
                item.moneySearch.text="1000 VND"
            }
            else if indexPath.row==1{
                item.imgSearch.image=UIImage(named: "bill")
                item.nameSearch.text="Bill"
                item.daySearch.text="25/04/2023"
                item.moneySearch.text="20000 VND"
            }
            else{
                item.imgSearch.image=UIImage(named: "salary")
                item.nameSearch.text="Salary"
                item.daySearch.text="26/04/2023"
                item.moneySearch.text="1000 VND"
                item.moneySearch.textColor=UIColor.green
            }
            return item
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
            return 3
        }
        else if tableView.tag==1{
            return 2
        }
        else if tableView.tag==2{
            return cateList.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag==0{
            let edit=storyboard?.instantiateViewController(withIdentifier: "EditScreen")as!EditViewController
            self.navigationController?.pushViewController(edit, animated: true)
        }
        else if tableView.tag==1{
            tableDay.isHidden=true
            btnDay.setTitle(optionDay[indexPath.row], for: .normal  )
        }
        else if tableView.tag==2{
            tableCate.isHidden=true
            btnCate.setTitle(cateList[indexPath.row].getCateName(), for: .normal  )
        }
        
    }
    @IBAction func btnDay(_ sender: UIButton) {
        tableDay.isHidden=false
    }
    @IBAction func btnCate(_ sender: UIButton) {
        tableCate.isHidden=false
        print(cateList.count)
    }
}
