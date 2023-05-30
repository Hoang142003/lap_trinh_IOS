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
    public func Khoitaogiatri(){
        
        if open(){
            let sql="INSERT INTO \(MONEY) (\(MONEY)) VALUES(?)"
            if database!.executeUpdate(sql, withArgumentsIn: [500000]){
                
                os_log("Bien a duoc ghi thanh cong vao database")
            }
            else{
                os_log("Khong the ghi a vao database")
            }
            let _=close()
        }
    }
}
