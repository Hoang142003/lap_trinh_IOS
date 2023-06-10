import UIKit
// Chua sua
class ThongKeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var lblThu: UILabel!
    @IBOutlet weak var lblChi: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var dao:Database_layer!
    var arrGiaoDich: [GiaoDich] = []
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        dao=Database_layer()
        
        let items = ["Ngày", "Tuần", "Tháng"]
        
        // Xoá tất cả các segment cũ
        segmentControl.removeAllSegments()
        
        // Thêm các segment mới từ mảng items
        for (index, item) in items.enumerated() {
            segmentControl.insertSegment(withTitle: item, at: index, animated: false)
        }
        
        // Mặc định chọn option đầu tiên (Ngay)
        segmentControl.selectedSegmentIndex = 0
        
        // Tạo mảng giao dịch ngẫu nhiên
        arrGiaoDich = createRandomGiaoDich()
        
        // Gọi phương thức segmentedControlValueChanged lần đầu
        segmentedControlValueChanged(segmentControl)
        
        segmentControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        // Thêm segmented control vào view hiện tại
        view.addSubview(segmentControl)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrGiaoDich = createRandomGiaoDich()
        tableView.reloadData()
        segmentControl.selectedSegmentIndex = 1
        segmentedControlValueChanged(segmentControl)
        segmentControl.selectedSegmentIndex = 0
    }
    // MARK: Xu li khi chon segment
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        func calculateTotalAndPercentageForCurrentDay() -> [ChiTieu] {
            let currentDate = Date()
            
            var totalAmountByCategory: [String: Double] = [:]
            var totalAmount: Double = 0
            
            for transaction in arrGiaoDich where transaction.soTien < 0 {
                guard let transactionDate = transaction.toDate(), Calendar.current.isDate(transactionDate, inSameDayAs: currentDate) else {
                    continue
                }
                
                let category = transaction.loaiGiaoDich
                let amount = Double(transaction.soTien)
                
                totalAmountByCategory[category, default: 0] += amount
                totalAmount += amount
            }
            
            var chiTieuArray: [ChiTieu] = []
            
            for (category, amount) in totalAmountByCategory {
                let percentage = (amount / totalAmount) * 100
                let chiTieu = ChiTieu(tenAnh: "tenAnh", tenGiaoDich: category, tongTien: Int(amount), phanTram: String(format: "%.1f", percentage) + "%")
                chiTieuArray.append(chiTieu)
                
                
            }
            
            return chiTieuArray
        }
        
        func calculateTotalAndPercentageForCurrentWeek() -> [ChiTieu] {
            let currentDate = Date()
            let calendar = Calendar.current
            
            guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: currentDate)?.start else {
                return []
            }
            
            let endOfWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: startOfWeek)
            
            var totalAmountByCategory: [String: Double] = [:]
            var totalAmount: Double = 0
            var chiTieuArray: [ChiTieu] = []
            
            for transaction in arrGiaoDich where transaction.soTien < 0 {
                guard let transactionDate = transaction.toDate() else {
                    continue
                }
                
                if transactionDate >= startOfWeek, transactionDate < endOfWeek! {
                    let category = transaction.loaiGiaoDich
                    let amount = Double(transaction.soTien)
                    
                    totalAmountByCategory[category, default: 0] += amount
                    totalAmount += amount
                }
            }
            
            for (category, amount) in totalAmountByCategory {
                let percentage = (amount / totalAmount) * 100
                let chiTieu = ChiTieu(tenAnh: "tenAnh", tenGiaoDich: category, tongTien: Int(amount), phanTram: String(format: "%.1f", percentage) + "%")
                chiTieuArray.append(chiTieu)
            }
            
            return chiTieuArray
        }
        
        func calculateTotalAndPercentageForCurrentMonth() -> [ChiTieu] {
            let currentDate = Date()
            let currentMonth = Calendar.current.component(.month, from: currentDate)
            let currentYear = Calendar.current.component(.year, from: currentDate)
            
            var totalAmountByCategory: [String: Double] = [:]
            var totalAmount: Double = 0
            var chiTieuArray: [ChiTieu] = []
            
            for transaction in arrGiaoDich where transaction.soTien < 0 {
                guard let transactionDate = transaction.toDate(), Calendar.current.component(.month, from: transactionDate) == currentMonth, Calendar.current.component(.year, from: transactionDate) == currentYear else {
                    continue
                }
                
                let category = transaction.loaiGiaoDich
                let amount = Double(transaction.soTien)
                
                totalAmountByCategory[category, default: 0] += amount
                totalAmount += amount
            }
            
            for (category, amount) in totalAmountByCategory {
                let percentage = (amount / totalAmount) * 100
                let chiTieu = ChiTieu(tenAnh: "tenAnh", tenGiaoDich: category, tongTien: Int(amount), phanTram: String(format: "%.1f", percentage) + "%")
                chiTieuArray.append(chiTieu)
            }
            
            return chiTieuArray
        }
        
        //
        let selectedIndex = sender.selectedSegmentIndex
        if selectedIndex == 0 {
            data = calculateTotalAndPercentageForCurrentDay()
            
            // Tính tổng thu chi trong ngày hiện tại
            let currentDate = Date()
            let calendar = Calendar.current
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            let totalThuNhap = arrGiaoDich.reduce(0) { result, transaction in
                if let transactionDate = transaction.toDate(), calendar.isDate(transactionDate, inSameDayAs: currentDate), transaction.soTien > 0 {
                    return result + transaction.soTien
                } else {
                    return result
                }
            }
            
            let totalChiTieu = 0 - arrGiaoDich.reduce(0) { result, transaction in
                if let transactionDate = transaction.toDate(), calendar.isDate(transactionDate, inSameDayAs: currentDate), transaction.soTien < 0 {
                    return result + transaction.soTien
                } else {
                    return result
                }
            }
            
            lblThu.text = "\(totalThuNhap) vnd"
            lblChi.text = "\(totalChiTieu) vnd"
        }
        else if selectedIndex == 1 {
            data = calculateTotalAndPercentageForCurrentWeek()
            
            // Tính tổng thu chi trong tuần hiện tại
            let currentDate = Date()
            let calendar = Calendar.current
            let currentWeek = calendar.component(.weekOfYear, from: currentDate)
            let currentYear = calendar.component(.year, from: currentDate)
            let totalThuNhap = arrGiaoDich.reduce(0) { $0 + ($1.soTien > 0 && getWeek(from: $1.ngay) == currentWeek && getYear(from: $1.ngay) == currentYear ? $1.soTien : 0) }
            let totalChiTieu = 0 - arrGiaoDich.reduce(0) { $0 + ($1.soTien < 0 && getWeek(from: $1.ngay) == currentWeek && getYear(from: $1.ngay) == currentYear ? $1.soTien : 0) }
            
            // Set text cho các label
            lblThu.text = "\(totalThuNhap) vnd"
            lblChi.text = "\(totalChiTieu) vnd"
        } else {
            data = calculateTotalAndPercentageForCurrentMonth()
            
            // Tính tổng thu chi trong tháng hiện tại
            // Tính tổng thu chi trong tháng hiện tại
            let currentDate = Date()
            let calendar = Calendar.current
            let currentMonth = calendar.component(.month, from: currentDate)
            let currentYear = calendar.component(.year, from: currentDate)
            
            let totalThuNhap = arrGiaoDich.reduce(0) { result, transaction in
                if let transactionDate = transaction.toDate() {
                    let transactionMonth = calendar.component(.month, from: transactionDate)
                    let transactionYear = calendar.component(.year, from: transactionDate)
                    let isSameMonthAndYear = transactionMonth == currentMonth && transactionYear == currentYear
                    let isPositiveAmount = transaction.soTien > 0
                    
                    if isSameMonthAndYear && isPositiveAmount {
                        return result + transaction.soTien
                    }
                }
                
                return result
            }
            
            let totalChiTieu = 0 - arrGiaoDich.reduce(0) { result, transaction in
                if let transactionDate = transaction.toDate() {
                    let transactionMonth = calendar.component(.month, from: transactionDate)
                    let transactionYear = calendar.component(.year, from: transactionDate)
                    let isSameMonthAndYear = transactionMonth == currentMonth && transactionYear == currentYear
                    let isNegativeAmount = transaction.soTien < 0
                    
                    if isSameMonthAndYear && isNegativeAmount {
                        return result + transaction.soTien
                    }
                }
                
                return result
            }
            
            lblThu.text = "\(totalThuNhap) vnd"
            lblChi.text = "\(totalChiTieu) vnd"
            
        }
        tableView.reloadData()
    }
    
    // Hàm tạo mảng giao dịch ngẫu nhiên
    func createRandomGiaoDich() -> [GiaoDich] {
        var arrGiaoDich = [GiaoDich]()
        arrGiaoDich.removeAll()
        dao.getAllHistoryWithDate(arrGiaoDich: &arrGiaoDich)
        
        print(arrGiaoDich)
        
        return arrGiaoDich
    }
    
    // MARK: Label Thu chi
    
    
    
    
    // Hàm trích xuất ngày từ ngày giao dịch
    func getDay(from dateString: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: dateString)
        
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date ?? Date())
        
        return day
    }
    
    // Hàm trích xuất tuần từ ngày giao dịch
    func getWeek(from dateString: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        let calendar = Calendar.current
        let week = calendar.component(.weekOfYear, from: date)
        return week
    }
    
    
    // Hàm trích xuất tháng từ ngày giao dịch
    func getMonth(from dateString: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: dateString)
        
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date ?? Date())
        
        return month
    }
    
    // Hàm trích xuất năm từ ngày giao dịch
    func getYear(from dateString: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: dateString)
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date ?? Date())
        
        return year
    }
    
    
    
    // MARK: TableView thong ke
    // Bang
    var data: [ChiTieu] = [
//        ChiTieu(tenAnh: "anh1", tenGiaoDich: "An uong", tongTien: 1000, phanTram: "30"),
//        ChiTieu(tenAnh: "anh2", tenGiaoDich: "Di lai", tongTien: 300, phanTram: "10"),
//        ChiTieu(tenAnh: "anh3", tenGiaoDich: "Choi", tongTien: 2000, phanTram: "60")
    ]
    
    // Protocol
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chiTieu = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ThongKeTableViewCell
        
        cell.lblChiTieu.text = chiTieu.tenGiaoDich
        if cell.lblChiTieu.text == "bonus"{
            cell.imgIcon.image = UIImage(named: "bonus")
        } else if cell.lblChiTieu.text == "food"{
            cell.imgIcon.image = UIImage(named: "food")
        }
        else if cell.lblChiTieu.text == "bill"{
            cell.imgIcon.image = UIImage(named: "bill")
        }
        else{
            cell.imgIcon.image = UIImage(named: "salary")
        }
        
        cell.lblTongTien.text = String(chiTieu.tongTien)
        cell.lblPhanTram.text = chiTieu.phanTram
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120;
    }
}

// Cấu trúc dữ liệu GiaoDich
struct GiaoDich {
    var ngayGiaoDich: String
    var loaiGiaoDich: String
    var soTien: Int
    var ngay: String
}

extension GiaoDich {
    func toDate(format: String = "dd/MM/yyyy") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: ngay)
    }
}

// Cấu trúc dữ liệu ChiTieu
struct ChiTieu {
    let tenAnh: String
    let tenGiaoDich: String
    let tongTien: Int
    let phanTram: String
}



