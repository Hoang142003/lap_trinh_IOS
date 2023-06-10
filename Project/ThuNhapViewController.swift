//
//  ThuNhapViewController.swift
//  Project
//
//  Created by CNTT on 6/1/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import UIKit

class ThuNhapViewController: UIViewController {

    @IBOutlet weak var btn_salary: UIButton!
    @IBOutlet weak var btn_Bonus: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Spending_Function(_ sender: UIButton) {
        if let navi = navigationController{
            navi.popViewController(animated: true)
        }
    }
    @IBAction func Salary_function(_ sender: UIButton) {
        let add=storyboard?.instantiateViewController(withIdentifier: "AddScreen")as!AddHistoryViewController
        add.category = btn_salary.titleLabel?.text
        self.navigationController?.pushViewController(add, animated: true)
    }
    @IBAction func btn_bonus(_ sender: UIButton) {
        let add=storyboard?.instantiateViewController(withIdentifier: "AddScreen")as!AddHistoryViewController
        add.category = btn_Bonus.titleLabel?.text
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
