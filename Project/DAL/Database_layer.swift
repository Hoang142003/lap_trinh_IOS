//
//  Database_layer.swift
//  Project
//
//  Created by CNTT on 5/29/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import Foundation
import UIKit
import os.log



class Database_layer{
//MARK: Database's properties
private let DB_NAME="chitieu.sqlite"
private let DB_PATH:String?
private let database:FMDatabase?
//MARK: Table's properties
//1. Table history
private let HISTORY_TABLE_NAME="History"
private let HISTORY_ID="history_id"
private let HISTORY_DATE_ID="date_id"
private let HISTORY_CATEGORY_ID="category_id"
private let HISTORY_MONEY="transaction_money"

//2. Table date
private let DATE_TABLE_NAME="Date"
private let DATE_ID="date_id"
private let DATE="date"
private let DATE_MONEY="money"
private let DATE_WALLET="wallet"

//3. Table category
private let CATEGORY_TABLE_NAME="Category"
private let CATEGORY_ID="category_id"
private let CATEGORY_NAME="category_name"
private let CATEGORY_LOAI="category_loai"

//4. Table money
private let MONEY_TABLE_NAME="Money"
private let MONEY_ID="money_id"
private let MONEY="money"


//MARK: Constructor
    init(){
        let directories=NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        DB_PATH=directories[0]+"/"+DB_NAME
        //khoi tao doi tuong database
        database=FMDatabase(path: DB_PATH)
        if database != nil{
            os_log("Khoi tao du lieu thanh cong")
            //Tao bang cho co so du lieu
            let _=tablesCreation()
        }
        else{
            os_log("Khong the khoi tao co so du lieu"
            )
        }
    }
    //////////////////////////////////////////////////
    //MARK: Dinh nghia cac ham Primitive
    //////////////////////////////////////////////////
    
    
    //1. Kiem tra su ton tai trong database
    private func isDatabaseExist()->Bool{
        return (database != nil)
    }
    
    //2. Mo database
    private func open()->Bool{
        var ok=false
        if isDatabaseExist(){
            if database!.open(){
                ok=true
                os_log("Mo co so du lieu thanh cong!")
            }
            else{
                os_log("Khong the mo co so du lieu!")
            }
            
        }
        return ok
    }
    
    //3. Dong co so du lieu
    private func close()->Bool{
        var ok=false
        if isDatabaseExist(){
            if database!.close(){
                ok=true
                os_log("Dong co so du lieu thanh cong!")
            }
            else{
                os_log("Khong the dong co so du lieu!")
            }
        }
        return ok
    }
    
    //4. Tao cac bang du lieu
    private func tablesCreation()->Bool{
        var ok=false
        if open(){
            //Table Date
            //xay dung cau lenh sql
            let sqlDate="CREATE TABLE \(DATE_TABLE_NAME) ("
                + DATE_ID+" INTEGER PRIMARY KEY AUTOINCREMENT, "
                + DATE+" DATE, "
                + DATE_MONEY+" DOUBLE, "
                + DATE_WALLET+" DOUBLE)"
            //thuc thi cau lenh sql
            if database!.executeStatements(sqlDate){
                ok=true
                os_log("Tao bang du lieu Date thanh cong!")
                
            }
            else{
                os_log("Khong the tao bang du lieu Date!")
            }
            //Table Category
            //xay dung cau lenh sql
            let sqlCate="CREATE TABLE \(CATEGORY_TABLE_NAME) ("
                + CATEGORY_ID+" INTEGER PRIMARY KEY AUTOINCREMENT, "
                + CATEGORY_NAME+" VARCHAR(255), "
                + CATEGORY_LOAI+" INT)"
            //thuc thi cau lenh sql
            if database!.executeStatements(sqlCate){
                ok=true
                os_log("Tao bang du lieu Category thanh cong!")
                
            }
            else{
                os_log("Khong the tao bang du lieu Category!")
            }
            //Table Money
            //xay dung cau lenh sql
            let sqlMoney="CREATE TABLE \(MONEY_TABLE_NAME) ("
                + MONEY_ID+" INTEGER PRIMARY KEY AUTOINCREMENT, "
                + MONEY+" DOUBLE)"
            //thuc thi cau lenh sql
            if database!.executeStatements(sqlMoney){
                ok=true
                os_log("Tao bang du lieu Money thanh cong!")
                
            }
            else{
                os_log("Khong the tao bang du lieu Money!")
            }
            //Table History
            //xay dung cau lenh sql
            let sqlHistory="CREATE TABLE \(HISTORY_TABLE_NAME) ("
                + HISTORY_ID+" INTEGER PRIMARY KEY AUTOINCREMENT, "
                + HISTORY_CATEGORY_ID+" INT, "
                + HISTORY_DATE_ID+" DATE, "
                + HISTORY_MONEY+" DOUBLE, FOREIGN KEY ("+HISTORY_CATEGORY_ID+") REFERENCES  "+CATEGORY_TABLE_NAME+" ("+CATEGORY_ID+"), FOREIGN KEY ("+HISTORY_DATE_ID+") REFERENCES  "+DATE_TABLE_NAME+" ("+DATE_ID+"))"
            //thuc thi cau lenh sql
            if database!.executeStatements(sqlHistory){
                ok=true
                os_log("Tao bang du lieu History thanh cong!")
                
            }
            else{
                os_log("Khong the tao bang du lieu History!")
            }
            let _=close()
        }
        return ok
    }
    /////////////////////////////////////////////////
    //MARK: Dinh nghia cac ham API
    //////////////////////////////////////////////////
    
    //1. Lay du lieu tu table Date
    public func getAllDate(dates:inout [Dates]){
        if open(){
            var result:FMResultSet?
            let sql="SELECT * FROM \(DATE_TABLE_NAME) ORDER BY \(DATE) DESC"
            do{
                result=try database?.executeQuery(sql, values: nil)
            }
            catch{
                os_log("Khong the doc date tu database")
            }
            if let result = result{
                while(result.next()){
                    let date_id=result.int(forColumn: DATE_ID)
                    let date_name=result.date(forColumn: DATE)
                    let date_money=result.double(forColumn: DATE_MONEY)
                    let date_wallet=result.double(forColumn: DATE_WALLET)
                    let date=Dates(date_id: Int(date_id), date: date_name!, money: Double(date_money),wallet:Double(date_wallet))
                    dates.append(date)
                }
            }
            let _=close()
        }
    }
    //1. Lay du lieu tu table Date
    public func getAllCate(categories:inout [Category]){
        if open(){
            var result:FMResultSet?
            let sql="SELECT * FROM \(CATEGORY_TABLE_NAME)"
            do{
                result=try database?.executeQuery(sql, values: nil)
            }
            catch{
                os_log("Khong the doc date tu database")
            }
            if let result = result{
                while(result.next()){
                    let cateid=result.int(forColumn: CATEGORY_ID)
                    let catename=result.string(forColumn: CATEGORY_NAME) ?? ""
                    let cateloai=result.int(forColumn: CATEGORY_LOAI)
                    let category=Category(category_id: Int(cateid), category_name: catename, category_loai: Int(cateloai))
                    categories.append(category)
                }
            }
            let _=close()
        }
    }
    public func getAllMoney(moneyCurrent:inout [Money]){
        if open(){
            var result:FMResultSet?
            let sql="SELECT * FROM \(MONEY_TABLE_NAME)"
            do{
                result=try database?.executeQuery(sql, values: nil)
            }
            catch{
                os_log("Khong the doc date tu database")
            }
            if let result = result{
                while(result.next()){
                    let moneyid=result.int(forColumn: MONEY_ID)
                    let money=result.double(forColumn: MONEY)
                    let moneyitem=Money(money_id: Int(moneyid), money: Double(money))
                    moneyCurrent.append(moneyitem)
                }
            }
            let _=close()
        }
    }
    public func getAllHistory(history:inout [History]){
        if open(){
            var result:FMResultSet?
            let sql="SELECT * FROM \(HISTORY_TABLE_NAME)"
            do{
                result=try database?.executeQuery(sql, values: nil)
            }
            catch{
                os_log("Khong the doc date tu database")
            }
            if let result = result{
                
                while(result.next()){
                    let history_id=result.int(forColumn: HISTORY_ID)
                    let category_id=result.int(forColumn: HISTORY_CATEGORY_ID)
                    let date_id=result.int(forColumn: HISTORY_DATE_ID)
                    let money=result.double(forColumn: HISTORY_MONEY)
                    let item=History(history_id: Int(history_id), category_id: Int(category_id), date_id: Int(date_id), transaction_money: Double(money))
                    history.append(item)
                }
            }
            let _=close()
        }
    }
    public func getHistory(date_id:Int,history:inout [History]){
        if open(){
            var result:FMResultSet?
            let sql="SELECT * FROM \(HISTORY_TABLE_NAME) WHERE \(HISTORY_DATE_ID)=\(date_id)"
            do{
                result=try database?.executeQuery(sql, values: nil)
            }
            catch{
                os_log("Khong the doc date tu database")
            }
            if let result = result{
                
                while(result.next()){
                    let history_id=result.int(forColumn: HISTORY_ID)
                    let category_id=result.int(forColumn: HISTORY_CATEGORY_ID)
                    let date_id=result.int(forColumn: HISTORY_DATE_ID)
                    let money=result.double(forColumn: HISTORY_MONEY)
                    let item=History(history_id: Int(history_id), category_id: Int(category_id), date_id: Int(date_id), transaction_money: Double(money))
                    history.append(item)
                }
            }
            let _=close()
        }
    }
    
    public func getAllHistoryWithDate(arrGiaoDich: inout [GiaoDich]) {
        if open() {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            
            let result: FMResultSet? = database?.executeQuery("SELECT * FROM \(HISTORY_TABLE_NAME) JOIN \(DATE_TABLE_NAME) ON \(HISTORY_TABLE_NAME).\(HISTORY_DATE_ID)=\(DATE_TABLE_NAME).\(DATE_ID)", withArgumentsIn: [])
            
            while result?.next() == true {
                if let historyDate = result?.date(forColumn: DATE) {
                    let ngayHienTai = formatter.string(from: historyDate)
                    
                    var loaigd = result?.string(forColumn: CATEGORY_ID)
                    if loaigd == "9" {
                        loaigd = "food"
                    } else if loaigd == "7" {
                        loaigd = "bill"
                    } else if loaigd == "8" {
                        loaigd = "salary"
                    } else {
                        loaigd = "bonus"
                    }
                    
                    let dateSqlite = result?.string(forColumn: DATE)
                    
                    let gd = GiaoDich(ngayGiaoDich: ngayHienTai, loaiGiaoDich: loaigd!, soTien: Int(result?.int(forColumn: HISTORY_MONEY) ?? 0), ngay: ngayHienTai)
                    arrGiaoDich.append(gd)
                }
            }
            let _ = close()
        }
    }

    
    public func getCategory(cate_id:Int,categories:inout Category){
        if open(){
            var result:FMResultSet?
            let sql="SELECT * FROM \(CATEGORY_TABLE_NAME) WHERE \(CATEGORY_ID)=\(cate_id)"
            do{
                result=try database?.executeQuery(sql, values: nil)
            }
            catch{
                os_log("Khong the doc date tu database")
            }
            if let result = result{
                while(result.next()){
                    let cateid=result.int(forColumn: CATEGORY_ID)
                    let catename=result.string(forColumn: CATEGORY_NAME) ?? ""
                    let cateloai=result.int(forColumn: CATEGORY_LOAI)
                    let category=Category(category_id: Int(cateid), category_name: catename, category_loai: Int(cateloai))
                    categories=category
                }
            }
            let _=close()
        }
    }
    public func getDate(date_id:Int,dates:inout Dates){
        if open(){
            var result:FMResultSet?
            let sql="SELECT * FROM \(DATE_TABLE_NAME) WHERE \(DATE_ID)=\(date_id)"
            do{
                result=try database?.executeQuery(sql, values: nil)
            }
            catch{
                os_log("Khong the doc date tu database")
            }
            if let result = result{
                while(result.next()){
                    let date_id=result.int(forColumn: DATE_ID)
                    let date_name=result.date(forColumn: DATE)
                    let date_money=result.double(forColumn: DATE_MONEY)
                    let date_wallet=result.double(forColumn: DATE_WALLET)
                    let date=Dates(date_id: Int(date_id), date: date_name!, money: Double(date_money),wallet:Double(date_wallet))
                    dates=date
                }
            }
            let _=close()
        }
    }
    public func SearchCate(cate_id:Int,history:inout [History]){
        
        if open(){
            var sql=""
            var result:FMResultSet?
            if cate_id==0{
                sql = "SELECT * FROM \(HISTORY_TABLE_NAME)"
                os_log("test")
            }
            else{
                sql = "SELECT * FROM \(HISTORY_TABLE_NAME) WHERE  \(HISTORY_CATEGORY_ID)=\(cate_id)"
            }
            do{
                result=try database?.executeQuery(sql, values: nil)
                
            }
            catch{
                os_log("Khong the truy van tu database")
            }
            if let result = result{
                while(result.next()){
                    let history_id=result.int(forColumn: HISTORY_ID)
                    let category_id=result.int(forColumn: HISTORY_CATEGORY_ID)
                    let date_id=result.int(forColumn: HISTORY_DATE_ID)
                    let money=result.double(forColumn: HISTORY_MONEY)
                    let item=History(history_id: Int(history_id), category_id: Int(category_id), date_id: Int(date_id), transaction_money: Double(money))
                    history.append(item)
                }
            }
            let _=close()
        }
    }
    public func Update_Date(d_id:Int, m_New:Double, w_New:Double)
    {
        if open(){
            
            let sql="UPDATE \(DATE_TABLE_NAME) SET \(DATE_MONEY)=?, \(DATE_WALLET)=? WHERE \(DATE_ID)=?"
            if database!.executeUpdate(sql, withArgumentsIn: [m_New, w_New, d_id]){
                
                os_log("Sua du lieu thanh cong vao database")
            }
            else{
                os_log("Khong the ghi du lieu vao database")
            }
            let _=close()
        }
    }
    public func Update_History(h_id:Int, d_id_New:Int, cate_id_New:Int, h_m_New:Double)
    {
        if open(){
            
            let sql="UPDATE \(HISTORY_TABLE_NAME) SET \(HISTORY_DATE_ID)=?, \(HISTORY_CATEGORY_ID)=?, \(HISTORY_MONEY)=? WHERE \(HISTORY_ID)=?"
            if database!.executeUpdate(sql, withArgumentsIn: [d_id_New, cate_id_New, h_m_New, h_id]){
                
                os_log("Sua du lieu thanh cong vao database")
            }
            else{
                os_log("Khong the ghi du lieu vao database")
            }
            let _=close()
        }
    }
    public func Update_Money(money_id:Int, money_New:Double)
    {
        if open(){
            
            let sql="UPDATE \(MONEY_TABLE_NAME) SET \(MONEY)=? WHERE \(MONEY_ID)=?"
            if database!.executeUpdate(sql, withArgumentsIn: [money_New, money_id]){
                
                os_log("Sua du lieu thanh cong vao database")
            }
            else{
                os_log("Khong the ghi du lieu vao database")
            }
            let _=close()
        }
    }
    
    public func Insert_Date(date_New:Date, m_New:Double, w_New:Double){
        
        if open(){
            
            let sql="INSERT INTO \(DATE_TABLE_NAME) (\(DATE), \(DATE_MONEY), \(DATE_WALLET)) VALUES(?,?,?)"
            if database!.executeUpdate(sql, withArgumentsIn: [date_New, m_New, w_New]){
                
                os_log("Them thanh cong")
            }
            else{
                os_log("Khong the ghi vao bang DATE")
            }
            let _=close()
        }
    }
    public func Update_History_Test()
    {
        if open(){
            
            let sql="UPDATE \(HISTORY_TABLE_NAME) SET \(HISTORY_MONEY) = -3000 WHERE \(HISTORY_ID) = 3"
            if database!.executeUpdate(sql, withArgumentsIn: [2]){
                
                os_log("Sua du lieu thanh cong vao database")
            }
            else{
                os_log("Khong the ghi du lieu vao database")
            }
            let _=close()
        }
    }
    public func Remove_Date(date_id:Int){
        if open(){
            
            let sql="DELETE FROM \(DATE_TABLE_NAME) WHERE \(DATE_ID)=\(date_id)"
            if database!.executeStatements(sql){
                
                os_log("OK")
            }
            else{
                os_log("No OK")
            }
            let _=close()
        }
    }
    public func Remove_History(history_id:Int){
        if open(){
            
            let sql="DELETE FROM \(HISTORY_TABLE_NAME) WHERE \(HISTORY_ID)=\(history_id)"
            if database!.executeStatements(sql){
                
                os_log("OK")
            }
            else{
                os_log("No OK")
            }
            let _=close()
        }
    }
    public func Insert_Cate(cateName_New:String, cateLoai_New:Int){
        //3. Table category
        if open(){
            
            let sql="INSERT INTO \(CATEGORY_TABLE_NAME) (\(CATEGORY_NAME), \(CATEGORY_LOAI)) VALUES(?,?)"
            if database!.executeUpdate(sql, withArgumentsIn: [cateName_New, cateLoai_New]){
                
                os_log("Them thanh cong")
            }
            else{
                os_log("Khong the ghi vao database")
            }
            let _=close()
        }
    }
    public func Insert_Money(money:Double){
        if open(){
            
            let sql="INSERT INTO \(MONEY_TABLE_NAME) (\(MONEY)) VALUES(?)"
            if database!.executeUpdate(sql, withArgumentsIn: [money]){
                
                os_log("Them thanh cong")
            }
            else{
                os_log("Khong the ghi vao database")
            }
            let _=close()
    }
    }
        
    public func Insert_CateNew(cateId:Int,cateName_New:String, cateLoai_New:Int){
        //3. Table category
        if open(){
            
            let sql="INSERT INTO \(CATEGORY_TABLE_NAME) (\(CATEGORY_ID), \(CATEGORY_NAME), \(CATEGORY_LOAI)) VALUES(?,?,?)"
            if database!.executeUpdate(sql, withArgumentsIn: [cateId, cateName_New, cateLoai_New]){
                
                os_log("Them thanh cong")
            }
            else{
                os_log("Khong the ghi vao database")
            }
            let _=close()
        }
    }
    public func RemoveDate()
    {
        if open(){
            
            let sql="DROP TABLE \(DATE_TABLE_NAME)"
            if database!.executeStatements(sql){
                
                os_log("OK")
            }
            else{
                os_log("No OK")
            }
            let _=close()
        }
    }
    public func RemoveHistory()
    {
        if open(){
            
            let sql="DROP TABLE \(HISTORY_TABLE_NAME)"
            if database!.executeStatements(sql){
                
                os_log("OK")
            }
            else{
                os_log("No OK")
            }
            let _=close()
        }
    }
    public func Date_Sample(date_New:Date, m_New:Double, w_New:Double){
        
        if open(){
            
            let sql="INSERT INTO \(DATE_TABLE_NAME) (\(DATE), \(DATE_MONEY), \(DATE_WALLET)) VALUES(?,?,?)"
            if database!.executeUpdate(sql, withArgumentsIn: [date_New, m_New, w_New]){
                
                os_log("Them thanh cong")
            }
            else{
                os_log("Khong the ghi vao database")
            }
            let _=close()
        }
    }
    public func date_Sample(date_New:Date, m_New:Double, w_New:Double){
        
        if open(){
            
            let sql="INSERT INTO \(DATE_TABLE_NAME) (\(DATE), \(DATE_MONEY), \(DATE_WALLET)) VALUES(?,?,?)"
            if database!.executeUpdate(sql, withArgumentsIn: [date_New, m_New, w_New]){
                
                os_log("Them thanh cong")
            }
            else{
                os_log("Khong the ghi vao database")
            }
            let _=close()
        }
    }
    public func history_Sample(d_id_New:Int, cate_id_New:Int, h_m_New:Double){
        if open(){
            
            let sql="INSERT INTO \(HISTORY_TABLE_NAME) (\(HISTORY_DATE_ID), \(HISTORY_CATEGORY_ID), \(HISTORY_MONEY)) VALUES(?,?,?)"
            if database!.executeUpdate(sql, withArgumentsIn: [d_id_New, cate_id_New, h_m_New]){
                
                os_log("Them thanh cong")
            }
            else{
                os_log("Khong the ghi vao database")
            }
            let _=close()
        }
    }
}
