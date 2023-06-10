//
//  ViewController.swift
//  BarChart
//
//  Created by Taof on 5/8/19.
//  Copyright © 2019 Taof. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var basicBarChart: BasicBarChart!
    @IBOutlet weak var barChart: BeautifulBarChart!
    private var dao:Database_layer!
    private var dateList=[Dates]()
    private var historyList=[History]()
    override func viewDidLoad() {
        super.viewDidLoad()
        dao=Database_layer()
        //                dao.RemoveDate()
        //                dao.RemoveHistory()
        //                dao.Date_Sample(date_New: Date(), m_New: -2000, w_New: 503000)
        //                dao.history_Sample(d_id_New: 1, cate_id_New: 7, h_m_New: -1000)
        //                dao.history_Sample(d_id_New: 1, cate_id_New: 7, h_m_New: -1000)
        dao.getAllDate(dates: &dateList)
        dao.getAllHistory(history: &historyList)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let dataEntries = generateDataEntries()
        basicBarChart.dataEntries = dataEntries
        barChart.dataEntries = dataEntries
    }
    
    func generateDataEntries() -> [BarEntry] {
        
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
        var result: [BarEntry] = []
        for i in 0..<dateList.count {
            var value:Double=0
            
            for h in historyList{
                if dateList[i].getDateID()==h.getDateID(){
                    if h.getTransactionMoney()<0{
                        value += h.getTransactionMoney()
                        print(h.getTransactionMoney())
                    }
                }
            }
            
            let height: Float = Float(value*(-1)) / 10000.0
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d/M/yyyy " 
            var date = Date()
            date=dateList[i].getDate()
            result.append(BarEntry(color: colors[i % colors.count], height: height, textValue: "\(value)", title: formatter.string(from: date)))
            value=0
        }
        return result
    }
    
}

