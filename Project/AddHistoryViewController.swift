//
//  AddHistoryViewController.swift
//  Project
//
//  Created by CNTT on 6/1/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import UIKit

class AddHistoryViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    
    public var category:String!
    private var dao:Database_layer!
    private var cateList=[Category]()
    private var dateList = [Dates]()
    @IBOutlet weak var btn_category: UIButton!
    @IBOutlet weak var tfMoney: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    
    @IBOutlet weak var myTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.dataSource=self
        myTable.delegate=self
        myTable.isHidden=true
        date.backgroundColor=UIColor.white
        btn_category.setTitle(category, for: .normal)
        //khoi tao database
        dao=Database_layer()
        dao.getAllCate(categories: &cateList)
        dao.getAllDate(dates: &dateList)
        dao.getAllMoney(moneyCurrent: &SpendingController.moneyCurrent)
        // Do any additional setup after loading the view.
    }
    @IBAction func btn_Category(_ sender: UIButton) {
        myTable.isHidden=false
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = tableView.dequeueReusableCell(withIdentifier: "CELL")
        item?.textLabel?.text=cateList[indexPath.row].getCateName()
        return item!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTable.isHidden=true
        btn_category.setTitle(cateList[indexPath.row].getCateName(), for: .normal)
    }
    
    
    
    @IBAction func Save_Function(_ sender: UIButton) {
        let dateFormatter=DateFormatter()
        dateFormatter.dateFormat="dd/MM/yyyy"
        var c_id:Int!
        
        let c=btn_category.titleLabel?.text
        
        let d_form=date.date
        for cate in cateList{
            if cate.getCateName()==c{
                c_id=cate.getCateID()
            }
        }
        var checkOK=false
        for d in dateList{
            
            if  dateFormatter.string(from: d.getDate()) == dateFormatter.string(from: d_form){
                if let tienHT=Double(tfMoney.text!){
                    dao.Update_Date(d_id: d.getDateID(), m_New: d.getMoney()+tienHT, w_New: d.getWallet()+tienHT)
                    if SpendingController.moneyCurrent.count>0{
                        let money_New=SpendingController.moneyCurrent[0].getMoney()+tienHT
                        dao.Update_Money(money_id: SpendingController.moneyCurrent[0].getMoneyID(), money_New: money_New)
                        SpendingController.moneyCurrent[0].setMoney(money: money_New)
                    }
                    
                    var getD_New=[Dates]()
                    dao.getAllDate(dates: &getD_New)
                    let end=getD_New.count-1
                    var i=0
                    while i <= end{
                        if dateFormatter.string(from: getD_New[i].getDate())==dateFormatter.string(from: d_form){
                            if let tienHT=Double(tfMoney.text!){
                                dao.history_Sample(d_id_New: getD_New[i].getDateID(), cate_id_New: c_id, h_m_New: tienHT)
                                checkOK=true
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
            }
        }
        
        
        
        if checkOK==false{
            let d_New=date.date
            //them ngay moi
            if let tienHT=Double(tfMoney.text!){
                dao.Insert_Date(date_New: d_New, m_New: tienHT, w_New: 0)
            }
            //lay lai du lieu table date
            var getD_New=[Dates]()
            dao.getAllDate(dates: &getD_New)
            let end=getD_New.count-1
            var i=0
            while i <= end{
                if dateFormatter.string(from: getD_New[i].getDate())==dateFormatter.string(from: d_New){
                    if let tienHT=Double(tfMoney.text!){
                        dao.history_Sample(d_id_New: getD_New[i].getDateID(), cate_id_New: c_id, h_m_New: tienHT)
                        let money_New=SpendingController.moneyCurrent[0].getMoney()+tienHT
                         dao.Update_Money(money_id: SpendingController.moneyCurrent[0].getMoneyID(), money_New: money_New)
                        SpendingController.moneyCurrent[0].setMoney(money: money_New)
                        
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
                        dao.Update_Money(money_id: SpendingController.moneyCurrent[0].getMoneyID(), money_New: getD_New[0].getWallet())
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
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


