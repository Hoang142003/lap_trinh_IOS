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
        //khoi tao du lieu
//        let date=Date()
//        dao.Khoitaogiatri(date: date, money: -2000, wallet: 498000)
        
        //Doc toan bo date tu database ve dateList
        dao.getAllDate(dates: &dateList)
        
        
        
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
        
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday, .day, .month, .year], from: dateList[indexPath.row].getDate())
        
        if let _ = components.weekday,
            let day = components.day,
            let _ = components.month,
            let year = components.year {
            let dateFormatter = DateFormatter()
            
            cell.day.text=String(day)
            
            
            // Lấy thứ
            dateFormatter.dateFormat = "EEEE"
            let weekdayString = dateFormatter.string(from: dateList[indexPath.row].getDate())
            cell.weekday.text=weekdayString
            
            
            // Lấy tháng
            dateFormatter.dateFormat = "MMMM"
            let monthString = dateFormatter.string(from: dateList[indexPath.row].getDate())
            cell.monthYear.text="\(monthString), \(year)"
            
        }
        if dateList[indexPath.row].getMoney()<0{
            cell.moneyDay.textColor=UIColor.red
        }
        else{
            cell.moneyDay.textColor=UIColor.green
        }
        if dateList[indexPath.row].getMoney().getDecimal() == 0{
            cell.moneyDay.text = String(format: "%0.0f",dateList[indexPath.row].getMoney())+" VND"
        }
        else{
            cell.moneyDay.text=String(dateList[indexPath.row].getMoney())+" VND"
        }
        
        if dateList[indexPath.row].getMoney().getDecimal() == 0{
            cell.moneyWallet.text = String(format: "%0.0f",dateList[indexPath.row].getWallet())+" VND"
        }
        else{
            cell.moneyWallet.text=String(dateList[indexPath.row].getWallet())+" VND"
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb=UIStoryboard.init(name: "Main", bundle: nil)
        let detail=sb.instantiateViewController(withIdentifier: "DetailScreen")as! DetailController
        detail.date_id=dateList[indexPath.row].getDateID()
        self.navigationController?.pushViewController(detail, animated: true)

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

