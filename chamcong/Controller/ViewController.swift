//
//  ViewController.swift
//  chamcong
//
//  Created by Quang Linh on 24/02/2024.
//

import UIKit
class ViewController: UIViewController {
    
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Backbtn: UINavigationItem!
    var connect = ConnectDB()
    var taikhoan = ""
    var matkhau = ""
    var deviceName = UIDevice.current.name
    var deviceModel = UIDevice.current.identifierForVendor!.uuidString
    
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
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
           
        
        
    }
    
    
    @IBAction func LogInPress(_ sender: Any){
        taikhoan = Username.text!
        matkhau = Password.text!
        
        
        
        connect.initConnect(){ (data) in
            if self.taikhoan.isEmpty || self.matkhau.isEmpty {
                // Hiển thị thông báo lỗi cho người dùng
                let alertController = UIAlertController(title: "Lỗi", message: "Vui lòng nhập tài khoản và mật khẩu", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
                
            } else {
                self.connect.client.execute("EXEC [dbo].[sp_sysLogin_AD] @nv = '\(self.taikhoan)', @pas = '\(self.matkhau)',@mamay = '27', @namedevi = '27';",completion: { [self] (_ results: ([Any]?)) in
                    
                    let results = results!.first! as! [[String: Any]]


                    if !results.isEmpty {
                        
                        self.performSegue(withIdentifier: "MainView", sender: nil)
                        
                        
                    } else {
                        
                        let alertController1 = UIAlertController(title: "Lỗi", message: "Tài khoản hoặc mật khẩu sai vui lòng nhập lại", preferredStyle: .alert)
                        let okAction1 = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController1.addAction(okAction1)
                        self.present(alertController1, animated: true, completion: nil)
                        
                    }
                    
                }
                                            
                                            
                )
            }
            
        }
        
        
    }
    
}

