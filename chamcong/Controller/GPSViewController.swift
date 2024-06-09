//
//  GPSController.swift
//  chamcong
//
//  Created by Quang Linh on 01/03/2024.
//

import UIKit
import CoreLocation

class GPSViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var VTtxt: UITextField!
    
    @IBOutlet weak var VTbtn: UIButton!
    
    @IBOutlet weak var danhsach: UITableView!
    
    let location = CLLocationManager()
    var lat: CLLocationDegrees!
    var lon: CLLocationDegrees!
    var connect = ConnectDB()
    let deviceName = UIDevice.current.name
    let deviceModel = UIDevice.current.identifierForVendor!.uuidString
    var ViTri: [ViTri] = []
    var headerViewCache: VT?
    var vSpinner : UIView?
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
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: {_ in self.dismiss(animated: false, completion: nil)})


        danhsach.dataSource = self
        danhsach.delegate = self
        danhsach.register(UINib(nibName: "VT", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        loadVT()
        
 
        
        
        
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
    
    func loadVT() {
        
        let ID = (navigationController?.viewControllers[1] as? ViewController)!.Username.text!
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

                DispatchQueue.main.async {
                    self.danhsach.reloadData()
                }
                
                
                i += 1
            }
        }
                                    
        )

    }

        


    
    
    @IBAction func addVT(_ sender: Any) {

        
        if VTtxt.text!.isEmpty  {
            let alertController = UIAlertController(title: "Lỗi", message: "Chưa nhập tên vị trí", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }else{

                        self.connect.client.execute("EXEC [dbo].[sp_InsertLocation_AD] @tenvt = '\(String(describing: VTtxt.text!))',@mamay = '\(deviceModel)', @kinhdo = '\(String(lon))', @vido = '\(String(lat))';",completion: { (_ results: ([Any]?)) in
                            let results = self.connect.convertStr(results: results, name: "KETQUA")
                            if results == "OK"{
                                let successAlert = UIAlertController(title: "Thành Công", message: "Thêm thành công", preferredStyle: .alert)
                                let okAction1 = UIAlertAction(title: "OK", style: .default, handler: nil)
                                successAlert.addAction(okAction1)
                                self.present(successAlert, animated: true) {
                                    self.loadVT()
                                        
                                                }

                                

                            }else{
                                let failAlert = UIAlertController(title: "Lỗi", message: "\(results)", preferredStyle: .alert)
                                let okAction2 = UIAlertAction(title: "OK", style: .default, handler: nil)
                                failAlert.addAction(okAction2)
                                self.present(failAlert, animated: true, completion: nil)
                               
                            }
                            
            
                        }
                        )

        }

    }
}















extension GPSViewController: CLLocationManagerDelegate {
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
extension GPSViewController:UITableViewDataSource,UITableViewDelegate{

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = headerViewCache {
                return headerView
            } else {
                let headerView = tableView.dequeueReusableCell(withIdentifier: "ReusableCell") as!  VT
                let borderWidth: CGFloat = 1.0
                let borderColor: CGColor = UIColor.gray.cgColor
                headerView.STT.layer.borderWidth = borderWidth
                headerView.STT.layer.borderColor = borderColor
                
                headerView.Vido.layer.borderWidth = borderWidth
                headerView.Vido.layer.borderColor = borderColor
                
                headerView.Kinhdo.layer.borderWidth = borderWidth
                headerView.Kinhdo.layer.borderColor = borderColor
                
                headerView.Tenvt.layer.borderWidth = borderWidth
                headerView.Tenvt.layer.borderColor = borderColor
                
                headerView.Mavt.layer.borderWidth = borderWidth
                headerView.Mavt.layer.borderColor = borderColor
                
                headerView.view.backgroundColor = UIColor.systemCyan
                
                headerView.STT.textColor = .white
                headerView.Vido.textColor = .white
                headerView.Kinhdo.textColor = .white
                headerView.Tenvt.textColor = .white
                headerView.Mavt.textColor = .white
                
                headerViewCache = headerView
                return headerView
            }
        }
    
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViTri.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.danhsach.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! VT
        guard indexPath.row < ViTri.count else {
                // Nếu không, trả về cell mặc định
                return cell
            }
        
            
        // Lấy phần tử tương ứng với indexPath từ mảng ViTri
        let item = ViTri[indexPath.row]
        
        // In ra thông tin của phần tử đó
        print("Thông tin vị trí:")
        print("STT: \(item.STT)")
        print("Vĩ độ: \(item.Vido)")
        print("Kinh độ: \(item.Kinhdo)")
        print("Tên vị trí: \(item.Tenvt)")
        print("Mã vị trí: \(item.Mavt)")
            
        cell.STT.text = "\(item.STT)"
       cell.Vido.text = "\(item.Vido)"
       cell.Tenvt.text = "\(item.Tenvt)"
       cell.Mavt.text = "\(item.Mavt)"
       cell.Kinhdo.text = "\(item.Kinhdo)"
    
    // Tạo đường viền cho mỗi label
        let borderWidth: CGFloat = 1.0
        let borderColor: CGColor = UIColor.gray.cgColor
        
        cell.STT.layer.borderWidth = borderWidth
        cell.STT.layer.borderColor = borderColor
        
        cell.Vido.layer.borderWidth = borderWidth
        cell.Vido.layer.borderColor = borderColor
        
        cell.Kinhdo.layer.borderWidth = borderWidth
        cell.Kinhdo.layer.borderColor = borderColor
        
        cell.Tenvt.layer.borderWidth = borderWidth
        cell.Tenvt.layer.borderColor = borderColor
        
        cell.Mavt.layer.borderWidth = borderWidth
        cell.Mavt.layer.borderColor = borderColor
        
        return cell
    }
    
    
        
}

