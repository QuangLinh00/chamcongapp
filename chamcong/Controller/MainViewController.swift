//
//  MainViewController.swift
//  chamcong
//
//  Created by Quang Linh on 15/03/2024.
//

import UIKit

class MainViewController: UIViewController,UINavigationControllerDelegate {
    
    @IBOutlet weak var chamcongBtn: UIButton!
    
    @IBOutlet weak var themvtBtn: UIButton!
    @IBOutlet weak var Backbtn: UINavigationItem!
    var connect = ConnectDB()
    lazy var ID = (navigationController?.viewControllers[1] as? ViewController)!.Username.text!
    
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
        navigationController?.delegate = self

        
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController == navigationController.viewControllers[1] {
            self.connect.disConnect()
            print("Back button pressed on root view controller")
        }
    }
    func checkRight() {
        self.connect.client.execute("EXEC [dbo].[sp_SelectQuyen_AD] @id_nv = '\(ID)';",completion: {(_ results: ([Any]?)) in
            
            let results = (results?.first! as! [[String : Any]]).first!
            print(results)
            
            switch (results["ID"] as! Int, results["Xem"] as! Int) {
            case (1, 1):
                self.performSegue(withIdentifier: "ThemVTView", sender: nil)
                break
            case (2, 1):
                let successAlert = UIAlertController(title: "Lỗi", message: "Không đủ quyền", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                successAlert.addAction(okAction)
                self.present(successAlert, animated: true)
            
            default:
                break
            }
                        
            
            

            
        })
    }
    
    @IBAction func ThemVT(_ sender: Any) {
        checkRight()
    }
}

