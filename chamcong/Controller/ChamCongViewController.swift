//
//  ChamCongViewController.swift
//  chamcong
//
//  Created by Quang Linh on 15/03/2024.
//

import UIKit
import Foundation
import CoreLocation

class ChamCongViewController: UIViewController {

    
    @IBOutlet weak var Namelb: UILabel!
    
    @IBOutlet weak var ChamCongTable: UITableView!
    @IBOutlet weak var chamconglb: UILabel!
    @IBOutlet weak var ChamCongbtn: UIButton!
    var connect = ConnectDB()
    public var name:String!
    lazy var ID = (navigationController?.viewControllers[1] as? ViewController)!.Username.text!
    lazy var MK = (navigationController?.viewControllers[1] as? ViewController)!.Password.text!
    var deviceName = UIDevice.current.name
    var deviceModel = UIDevice.current.identifierForVendor!.uuidString
    
    let location = CLLocationManager()
    var lat: CLLocationDegrees!
    var lon: CLLocationDegrees!
    var headerViewCache: ChamCong?
    var ChamCong: [ChamCongStruct] = []
    
    
    
    var ViTri: [ViTri] = []
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
    //        AppUtility.lockOrientation(.portrait)
            // Or to rotate and lock
             AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
            
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            // Don't forget to reset when view is being removed
            AppUtility.lockOrientation(.all)
        }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        showOverlays()
        location.delegate = self
        
        location.requestWhenInUseAuthorization()
        location.requestLocation()
        loadname()
        loadVT()
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: {_ in self.dismiss(animated: false, completion: nil)})
        
        
        ChamCongTable.dataSource = self
        ChamCongTable.delegate = self
        ChamCongTable.register(UINib(nibName: "ChamCong", bundle: nil), forCellReuseIdentifier: "ChamCongCell")
        loadChamCong()
        
        
        
        
        
        
        
    }
    func showOverlays() {
        let alert = UIAlertController(title: nil, message: "Đang Tải...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func loadChamCong() {
        ChamCong = []
        var ID = ""
        var MaVT = ""
        var Ngay = ""
        var Gio = ""
        self.connect.client.execute("select * from SYS_CHAMCONG_CT;",completion: { (_ results: ([Any]?)) in
            guard let results = results?.first as? [[String : Any]] else { return }
            for item in results {
                
                for (key, value) in item {
                    switch key {
                    case "MAVT":
                        MaVT = String(describing: value as! NSNumber)
                    case "ID_NV":
                        ID = value as! String
                    case "TRX_DATE":
                        Ngay = String(describing: value as! NSDate)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

                        // Chuyển đổi chuỗi thành đối tượng Date
                        let date = dateFormatter.date(from: Ngay )
                        // Định nghĩa DateFormatter khác để chuyển đối tượng Date thành chuỗi chỉ chứa ngày
                        let outputFormatter = DateFormatter()
                        outputFormatter.dateFormat = "dd-MM-yyyy"
                        outputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                        
                        Ngay = outputFormatter.string(from: date!)
                        
                        
                        
                    case "GIOCHAM":
                        Gio = String(describing: value as! NSDate)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

                        // Chuyển đổi chuỗi thành đối tượng Date
                        let date = dateFormatter.date(from: Gio )
                        // Định nghĩa DateFormatter khác để chuyển đối tượng Date thành chuỗi chỉ chứa ngày
                        let outputFormatter = DateFormatter()
                        outputFormatter.dateFormat = "HH:mm:ss"
                        outputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                        
                        Gio = outputFormatter.string(from: date!)
                        
                        
                    default:
                        break
                    }
                    
                    
                }
                let Newcell = chamcong.ChamCongStruct(Name: ID, VTName: MaVT, Date: Ngay, Time: Gio)
                self.ChamCong.append(Newcell)

                DispatchQueue.main.async {
                    self.ChamCongTable.reloadData()
                }
                
                
               
            }
                           
        }
                                    
        )

    }
    
    @IBAction func ChamcongPress(_ sender: Any) {
        let currentLocation = CLLocationCoordinate2D(latitude: Double(lat), longitude: Double(lon))
   
//        let radius = CLLocationDistance(Double(ViTri.first!.bankinh)!)

        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        for i in ViTri {
            let targetLocation = CLLocationCoordinate2D(latitude:Double(i.Vido)! , longitude: Double(i.Kinhdo)! )
            
            if isWithinRadius(currentCoordinate: currentLocation, targetCoordinate: targetLocation, radius: Double(ViTri.first!.bankinh)!){
                print("\(currentLocation),\(targetLocation)")
                self.connect.client.execute("DECLARE @thongbao NVARCHAR(200); EXEC [dbo].[sp_InsertTime_AD] @id_nv = '\(ID)',@mamay = '\(deviceModel)', @mavt = '\(Int(i.Mavt)!)',@thongbao = @thongbao OUTPUT ;SELECT @thongbao AS ThongBao;",completion: { (_ results: ([Any]?)) in
                    let results = self.connect.convertStr(results: results, name: "ThongBao")
                    
                    if !results.isEmpty {
                        let successAlert = UIAlertController(title: "Thành Công", message: "Chấm công thành công", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        successAlert.addAction(okAction)
                        self.present(successAlert, animated: true)
                        
                        self.loadChamCong()
                    }
                    
                    
                    
                    
                })}
//            else{
//                let successAlert1 = UIAlertController(title: "Lỗi", message: "Chấm công không thành công", preferredStyle: .alert)
//                let okAction1 = UIAlertAction(title: "OK", style: .default, handler: nil)
//                successAlert1.addAction(okAction1)
//                self.present(successAlert1, animated: true)
//            }
        }
        
    }
    
    
    func loadname()  {
        self.connect.client.execute("EXEC [dbo].[sp_sysLogin_AD] @nv = '\(ID)', @pas = '\(MK)',@mamay = '27', @namedevi = '27';",completion: { [self] (_ results: ([Any]?)) in
            let name = connect.convertStr(results: results, name: "NAME")
            
            Namelb.text = "tên tài khoản \n \(name)"
            
        })
                                    
        
    }
    func isWithinRadius(currentCoordinate: CLLocationCoordinate2D, targetCoordinate: CLLocationCoordinate2D, radius: Double) -> Bool {
        // Tạo CLLocation từ tọa độ mục tiêu
        let targetLocation = CLLocation(latitude: targetCoordinate.latitude, longitude: targetCoordinate.longitude)
        let currentLocation = CLLocation(latitude: currentCoordinate.latitude, longitude: currentCoordinate.longitude)
        // Tính khoảng cách giữa vị trí hiện tại và tọa độ mục tiêu
        let distance = currentLocation.distance(from: targetLocation)
        print(distance)
        // Kiểm tra xem khoảng cách có nhỏ hơn bán kính không
        return Double(distance) <= radius
    }
    func loadVT() {
        
        ViTri = []
        var vido = ""
        var kinhdo = ""
        var tenvt = ""
        var mavt = ""
        var bankinh = ""

        
        
        self.connect.client.execute("EXEC [dbo].[sp_SelectLocation_AD] @id_nv = '\(ID)';",completion: { (_ results: ([Any]?)) in
            guard let results = results?.first as? [[String : Any]] else { return }
            var i = 0
            
            for item in results {
                
                for (key, value) in item {
                    
                    switch key {
                    case "VIDO":
                        vido = value as! String
                    case "TENVT":
                        tenvt = value as! String
                        
                    case "MAVT":
                        mavt = (value as? NSNumber)!.stringValue
                    case "KINHDO":
                        kinhdo = value as! String
                    case "BANKINH":
                        bankinh = (value as? NSNumber)!.stringValue
                    default:
                        break
                    }
                    
                    
                }
                let newVT = chamcong.ViTri(STT: String(i), Vido: vido, Kinhdo: kinhdo, Tenvt: tenvt, Mavt: mavt,bankinh: bankinh)
                self.ViTri.append(newVT)
                i += 1
            }
        }
                                    
        )

    }

   
}
extension ChamCongViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            lat = location.coordinate.latitude
            lon = location.coordinate.longitude
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    
}
extension ChamCongViewController:UITableViewDataSource,UITableViewDelegate{
    
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = headerViewCache {
            return headerView
        } else {
            let headerView = tableView.dequeueReusableCell(withIdentifier: "ChamCongCell") as!  ChamCong
            let borderWidth: CGFloat = 1.0
            let borderColor: CGColor = UIColor.gray.cgColor
            headerView.MaNV.layer.borderWidth = borderWidth
            headerView.MaNV.layer.borderColor = borderColor
            
            headerView.NgayChamCong.layer.borderWidth = borderWidth
            headerView.NgayChamCong.layer.borderColor = borderColor
            
            headerView.GioChamCong.layer.borderWidth = borderWidth
            headerView.GioChamCong.layer.borderColor = borderColor
            
            headerView.MaVT.layer.borderWidth = borderWidth
            headerView.MaVT.layer.borderColor = borderColor
            
            
            
            headerView.View.backgroundColor = UIColor.systemCyan
            
            headerView.MaNV.textColor = .white
            headerView.NgayChamCong.textColor = .white
            headerView.GioChamCong.textColor = .white
            headerView.MaVT.textColor = .white
            
            
            headerViewCache = headerView
            return headerView
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChamCong.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.ChamCongTable.dequeueReusableCell(withIdentifier: "ChamCongCell", for: indexPath) as! ChamCong
        guard indexPath.row < ChamCong.count else {
            // Nếu không, trả về cell mặc định
            return cell
        }
        
        
        // Lấy phần tử tương ứng với indexPath từ mảng ViTri
        let item = ChamCong[indexPath.row]
        
        
        
        cell.MaNV.text = "\(item.Name)"
        cell.MaVT.text = "\(item.VTName)"
        cell.NgayChamCong.text = "\(item.Date)"
        cell.GioChamCong.text = "\(item.Time)"
        
        
        // Tạo đường viền cho mỗi label
        let borderWidth: CGFloat = 1.0
        let borderColor: CGColor = UIColor.gray.cgColor
        
        cell.MaNV.layer.borderWidth = borderWidth
        cell.MaNV.layer.borderColor = borderColor
        
        cell.MaVT.layer.borderWidth = borderWidth
        cell.MaVT.layer.borderColor = borderColor
        
        cell.NgayChamCong.layer.borderWidth = borderWidth
        cell.NgayChamCong.layer.borderColor = borderColor
        
        cell.GioChamCong.layer.borderWidth = borderWidth
        cell.GioChamCong.layer.borderColor = borderColor
        
        
        return cell
    }
    
}
        



