//
//  ChiTieuViewController.swift
//  Project
//
//  Created by CNTT on 6/1/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import UIKit

class ChiTieuViewController: UIViewController {
    @IBOutlet weak var btn_food: UIButton!
    @IBOutlet weak var btn_bill: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Income_Function(_ sender: Any) {
        let thunhap=storyboard?.instantiateViewController(withIdentifier: "TNScreen")as!ThuNhapViewController
        self.navigationController?.pushViewController(thunhap, animated: true)
    }
    
    @IBAction func btnFood(_ sender: UIButton) {
        let add=storyboard?.instantiateViewController(withIdentifier: "AddScreen")as!AddHistoryViewController
        add.category = btn_food.titleLabel?.text
        self.navigationController?.pushViewController(add, animated: true)
    }
    
    @IBAction func btnBill(_ sender: UIButton) {
        let add=storyboard?.instantiateViewController(withIdentifier: "AddScreen")as!AddHistoryViewController
        add.category = btn_bill.titleLabel?.text
        self.navigationController?.pushViewController(add, animated: true)
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
