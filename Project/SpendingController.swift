//
//  ViewController.swift
//  Project
//
//  Created by CNTT on 4/26/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import UIKit

class SpendingController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //Properties
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var viewMoney: UIView!
    private var dateList = [Dates]()
    private var dao:Database_layer!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.dataSource=self
        myTable.delegate=self
        myTable.layer.cornerRadius=10
        viewMoney.layer.cornerRadius=20
        //khoi tao doi tuong truy xuat database
        dao=Database_layer()
        //Doc toan bo date tu database ve dateList
        dao.getAllDate(dates: &dateList)
       
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "Cell")as! DongTableViewCell
        cell.day.text="26"
        cell.weekday.text="Wednesday"
        cell.monthYear.text="April, 2023"
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb=UIStoryboard.init(name: "Main", bundle: nil)
        let detail=sb.instantiateViewController(withIdentifier: "DetailScreen")as! DetailController
        self.navigationController?.pushViewController(detail, animated: true)
        print("a")
    }
 
    @IBAction func search(_ sender: UITapGestureRecognizer) {
        
        let search=storyboard?.instantiateViewController(withIdentifier: "searchScreen") as! SearchController
        self.navigationController?.pushViewController(search, animated: true)
    
    }
}

