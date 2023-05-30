//
//  History.swift
//  Project
//
//  Created by CNTT on 5/29/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import UIKit
class History{
    //MARK: Properties
    private var history_id:Int
    private var category_id:Int
    private var date_id:Int
    private var transaction_money:Double
    // Constructor
    init(history_id:Int,category_id:Int,date_id:Int,transaction_money:Double) {
        self.history_id=history_id
        self.category_id=category_id
        self.date_id=date_id
        self.transaction_money=transaction_money
    }
    //getter setter
    public func getHistoryID()->Int{
        return history_id
    }
    public func getCateID()->Int{
        return category_id
    }
    public func getDateID()->Int{
        return date_id
    }
    public func getTransactionMoney()->Double{
        return transaction_money
    }
}

