//
//  Money.swift
//  Project
//
//  Created by CNTT on 5/29/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import UIKit
class Money{
    //MARK: Properties
    private var money_id:Int
    private var money:Double
    // Constructor
    init(money_id:Int,money:Double) {
        self.money_id=money_id
        self.money=money
    }
    //getter setter
    public func getMoneyID()->Int{
        return money_id
    }
    public func getMoney()->Double{
        return money
    }
}
