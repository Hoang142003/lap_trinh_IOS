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
    public var history:History!
    private var dao:Database_layer!
    private var cateList=[Category]()
    private var dateList = [Dates]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(history.getHistoryID())
        btnBill.layer.cornerRadius=10
        tfMoney.layer.cornerRadius=10
        btnSave.layer.cornerRadius=10
        date.layer.cornerRadius=10
        date.backgroundColor=UIColor.white
        myTable.isHidden=true
        myTable.dataSource=self
        myTable.delegate=self
        //khoi tao database
        dao=Database_layer()
        //lay du lieu database
        dao.getAllCate(categories: &cateList)
        dao.getAllDate(dates: &dateList)
        //tim ten category
        for cate in cateList{
            if history.getCateID()==cate.getCateID(){
                btnBill.setTitle(cate.getCateName(), for: .normal)
            }
        }
        
        if history.getTransactionMoney().getDecimal() == 0{
            tfMoney.text = String(format: "%0.0f",history.getTransactionMoney())
        }
        else{
            tfMoney.text = String(history.getTransactionMoney())
        }
        //tim ngay
        for datea in dateList{
            if history.getDateID()==datea.getDateID(){
                date.setDate(datea.getDate(), animated: true)
            }
        }
        //
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTable.isHidden=true
        btnBill.setTitle(cateList[indexPath.row].getCateName(), for: .normal)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cateList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = tableView.dequeueReusableCell(withIdentifier: "CELL")
        item?.textLabel?.text=cateList[indexPath.row].getCateName()
        return item!
    }
    @IBAction func btnCate(_ sender: Any) {
        myTable.isHidden=false
    }
    @IBAction func SaveFunction(_ sender: UIButton) {
        let dateFormatter=DateFormatter()
        dateFormatter.dateFormat="dd/MM/yyyy"
        var c_id:Int!
        var d_id:Int!
        let c=btnBill.titleLabel?.text
        
        let d_form=date.date
        for cate in cateList{
            if cate.getCateName()==c{
                c_id=cate.getCateID()
            }
        }
        var datehientai=Date()
        for d in dateList{
            if d.getDateID()==history.getDateID(){
                datehientai=d.getDate()
                if  dateFormatter.string(from: datehientai) != dateFormatter.string(from: d_form){
                    dao.Update_Date(d_id: history.getDateID(), m_New: d.getMoney()-history.getTransactionMoney(), w_New: d.getWallet()-history.getTransactionMoney())
                }
            }
        }
        
        var checkOK=false
        for d in dateList{
            if dateFormatter.string(from: d.getDate())==dateFormatter.string(from: d_form){
                d_id=d.getDateID()
                let chitieu:Double!
                if let tienHT=Double(tfMoney.text!){
                    chitieu=tienHT - history.getTransactionMoney()
                    let mNew=d.getMoney()+chitieu
                    let wNew=d.getWallet()+chitieu
                    dao.Update_Date(d_id: d_id, m_New: mNew, w_New: wNew)
                    let money_New=SpendingController.moneyCurrent[0].getMoney()+chitieu
                    dao.Update_Money(money_id: SpendingController.moneyCurrent[0].getMoneyID(), money_New: money_New)
                    SpendingController.moneyCurrent[0].setMoney(money: money_New)
                    dao.Update_History(h_id: history.getHistoryID(), d_id_New: d.getDateID(), cate_id_New: c_id, h_m_New: tienHT)
                    var checkHis=[History]()
                    dao.getAllHistory(history: &checkHis)
                    var checkDate=false
                    for h in checkHis{
                        if h.getDateID()==history.getDateID(){
                            checkDate=true
                        }
                    }
                    if checkDate==false{
                        dao.Remove_Date(date_id: history.getDateID())
                    }
                    var getD_New=[Dates]()
                    dao.getAllDate(dates: &getD_New)
                    let end=getD_New.count-1
                    var i=0
                    while i <= end{
                        if dateFormatter.string(from: getD_New[i].getDate())==dateFormatter.string(from: d_form){
                           
                            
                            if i==0{
                                dao.Update_Date(d_id: getD_New[i].getDateID(), m_New: getD_New[i].getMoney(), w_New: SpendingController.moneyCurrent[0].getMoney())
                            }
                                
                            else{
                                let m_Up=getD_New[i-1].getMoney()
                                let w_Up=getD_New[i-1].getWallet()
                                let tienBanDau=w_Up-m_Up
                                dao.Update_Date(d_id: getD_New[i].getDateID(), m_New: getD_New[i].getMoney(), w_New: tienBanDau+getD_New[i].getMoney())
                                getD_New[i].setWallet(wallet: tienBanDau+getD_New[i].getMoney())
                                var start=i-1
                                while start>=0{
                                    let w_i_d:Double=getD_New[start+1].getWallet() + getD_New[start].getMoney()
                                    print(getD_New[start+1].getDate())
                                    dao.Update_Date(d_id: getD_New[start].getDateID(), m_New: getD_New[start].getMoney(), w_New: w_i_d)
                                    getD_New[start].setWallet(wallet: w_i_d)
                                    start-=1
                                }
                            }
                        }
                        i+=1
                    }
                    checkOK=true
                }
                
            }
            
        }
        if checkOK==false{
            let d_New=date.date
            //them ngay moi
            dao.Insert_Date(date_New: d_New, m_New: history.getTransactionMoney(), w_New: 0)
            //lay lai du lieu table date
            var getD_New=[Dates]()
            dao.getAllDate(dates: &getD_New)
            let end=getD_New.count-1
            var i=0
            while i <= end{
                if dateFormatter.string(from: getD_New[i].getDate())==dateFormatter.string(from: d_New){
                    if let tienHT=Double(tfMoney.text!){
                        dao.Update_History(h_id: history.getHistoryID(), d_id_New: getD_New[i].getDateID(), cate_id_New: c_id, h_m_New: tienHT)
                        var checkHis=[History]()
                        dao.getAllHistory(history: &checkHis)
                        var checkDate=false
                        for h in checkHis{
                            if h.getDateID()==history.getDateID(){
                                checkDate=true
                            }
                        }
                        if checkDate==false{
                            dao.Remove_Date(date_id: history.getDateID())
                        }
                    }
                     
                    if i==0{
                        dao.Update_Date(d_id: getD_New[i].getDateID(), m_New: getD_New[i].getMoney(), w_New: SpendingController.moneyCurrent[0].getMoney())
                    }
                       
                    else{
                        let m_Up=getD_New[i-1].getMoney()
                        let w_Up=getD_New[i-1].getWallet()
                        let tienBanDau=w_Up-m_Up
                        dao.Update_Date(d_id: getD_New[i].getDateID(), m_New: getD_New[i].getMoney(), w_New: tienBanDau+getD_New[i].getMoney())
                        getD_New[i].setWallet(wallet: tienBanDau+getD_New[i].getMoney())
                        var start=i-1
                        while start>=0{
                            let w_i_d:Double=getD_New[start+1].getWallet() + getD_New[start].getMoney()
                                    print(getD_New[start+1].getDate())
                            dao.Update_Date(d_id: getD_New[start].getDateID(), m_New: getD_New[start].getMoney(), w_New: w_i_d)
                            getD_New[start].setWallet(wallet: w_i_d)
                            start-=1
                        }
                    }
                }
                i+=1
            }
            
        }
        if let navi = navigationController{
            navi.popViewController(animated: true)
            navi.popViewController(animated: true)
        }
    }
    @IBAction func Del_function(_ sender: UITapGestureRecognizer) {
        
        let money_New=SpendingController.moneyCurrent[0].getMoney()-history.getTransactionMoney()
        dao.Update_Money(money_id: SpendingController.moneyCurrent[0].getMoneyID(), money_New: money_New)
        SpendingController.moneyCurrent[0].setMoney(money: money_New)
        var getD_New=[Dates]()
        dao.getAllDate(dates: &getD_New)
        let end=getD_New.count-1
        var i=0
        while i <= end{
            if getD_New[i].getDateID()==history.getDateID(){
                dao.Update_Date(d_id: getD_New[i].getDateID(), m_New: getD_New[i].getMoney()-history.getTransactionMoney(), w_New: getD_New[i].getWallet()-history.getTransactionMoney())
                getD_New[i].setMoney(money: getD_New[i].getMoney()-history.getTransactionMoney())
                dao.Remove_History(history_id: history.getHistoryID())
                    var checkHis=[History]()
                    dao.getAllHistory(history: &checkHis)
                    var checkDate=false
                    for h in checkHis{
                        if h.getDateID()==history.getDateID(){
                            checkDate=true
                        }
                    }
                    if checkDate==false{
                        dao.Remove_Date(date_id: history.getDateID())
                    }
                }
                
                if i==0{
                    print(SpendingController.moneyCurrent[0].getMoney())
                    dao.Update_Date(d_id: getD_New[i].getDateID(), m_New: getD_New[i].getMoney(), w_New: SpendingController.moneyCurrent[0].getMoney())
                }
                    
                else{
                    let m_Up=getD_New[i-1].getMoney()
                    let w_Up=getD_New[i-1].getWallet()
                    let tienBanDau=w_Up-m_Up
                    dao.Update_Date(d_id: getD_New[i].getDateID(), m_New: getD_New[i].getMoney(), w_New: tienBanDau+getD_New[i].getMoney())
                    getD_New[i].setWallet(wallet: tienBanDau+getD_New[i].getMoney())
                    var start=i-1
                    while start>=0{
                        let w_i_d:Double=getD_New[start+1].getWallet() + getD_New[start].getMoney()

                        dao.Update_Date(d_id: getD_New[start].getDateID(), m_New: getD_New[start].getMoney(), w_New: w_i_d)
                        getD_New[start].setWallet(wallet: w_i_d)
                        start-=1
                    }
                }
            i+=1
            }
        
        if let navi = navigationController{
            navi.popViewController(animated: true)
            navi.popViewController(animated: true)
        }
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
