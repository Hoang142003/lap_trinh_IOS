//
//  Category.swift
//  Project
//
//  Created by CNTT on 5/29/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import UIKit
class Category{
    //MARK: Properties
    private var category_id:Int
    private var category_name:String
    // Constructor
    init(category_id:Int,category_name:String) {
        self.category_id=category_id
        self.category_name=category_name
    }
    //getter setter
    public func getCateID()->Int{
        return category_id
    }
    public func getCateName()->String{
        return category_name
    }
}

