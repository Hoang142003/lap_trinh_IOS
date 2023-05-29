//
//  Date.swift
//  Project
//
//  Created by CNTT on 5/29/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import UIKit
class Dates{
    //MARK: Properties
    private var date_id:Int
    private var date:Date
    private var money:Double
    // Constructor
    init(date_id:Int,date:Date,money:Double) {
        self.date_id=date_id
        self.date=date
        self.money=money
    }
    //getter setter
    public func getDateID()->Int{
        return date_id
    }
    public func getDate()->Date{
        return date
    }
    public func getMoney()->Double{
        return money
    }
}
