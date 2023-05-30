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
    private var checkOpen=true
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var viewMoney: UIView!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var eyeActivity: UIImageView!
    private var dateList = [Dates]()
    private var moneyCurrent = [Money]()
    private var dao:Database_layer!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.dataSource=self
        myTable.delegate=self
        myTable.layer.cornerRadius=10
        viewMoney.layer.cornerRadius=20
        //khoi tao doi tuong truy xuat database
        dao=Database_layer()
        //doc du lieu money
        dao.getAllMoney(moneyCurrent: &moneyCurrent)
        if checkOpen == true{
         ShowMoney()
        }
        //Doc toan bo date tu database ve dateList
        dao.getAllDate(dates: &dateList)
        
        // Do any additional setup after loading the view.
    }
    private func ShowMoney(){
        if moneyCurrent[0].getMoney().getDecimal() == 0{
            money.text = String(format: "%0.0f",moneyCurrent[0].getMoney())+" VND"
        }
        else{
            
            money.text = String(format: "%0.\(moneyCurrent[0].getMoney().getDecimal())f",moneyCurrent[0].getMoney())+" VND"
        }
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
    @IBAction func eye(_ sender: UITapGestureRecognizer) {
        print("aa")
        money.text=""
        if(checkOpen==true){
            if moneyCurrent[0].getMoney().getNum() >= 0{
                for _ in 0..<moneyCurrent[0].getMoney().getNum(){
                    money.text?.append("*")
                }
                money.text?.append(" VND")
                eyeActivity.image=UIImage(named: "eye_close")
                checkOpen=false
            }
        }
        else{
            ShowMoney()
            eyeActivity.image=UIImage(named: "eye_open")
            checkOpen=true
        }
    }
    
}
extension Double{
    func getDecimal() -> Int {
        if !self.isNaN{
            let SoSauDauPhay=String(self).split(separator: ".")[1]
            return SoSauDauPhay=="0" ? 0 : SoSauDauPhay.count
        }
        else{
            return -1
        }
    }
    func getNum() -> Int {
        if !self.isNaN{
            let SoTruocDauPhay=String(self).split(separator: ".")[0]
            return SoTruocDauPhay.count
        }
        else{
            return -1
        }
    }
}

