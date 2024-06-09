//
//  LoadingViewController.swift
//  chamcong
//
//  Created by Quang Linh on 04/06/2024.
//

import Foundation
import UIKit

class LoadingViewController: UIViewController,UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
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
        
        spinner.startAnimating();
        NotificationCenter.default
                    .addObserver(self,
                                 selector: #selector(statusManager),
                                 name: .flagsChanged,
                                 object: nil)
                updateUserInterface()
        
       
        

        
    }
    func updateUserInterface() {
            switch Network.reachability.status {
            case .unreachable:
                let alertController = UIAlertController(title: "Lỗi", message: "Không thể kết nối tới máy chủ", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default){_ in
                    exit(0)}
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            case .wwan:
                print(" ")
            case .wifi:
                Timer.scheduledTimer(withTimeInterval: 2.0,repeats: false){_ in
                    self.performSegue(withIdentifier: "LoginView", sender: nil)
                    self.spinner.stopAnimating()
                    
                }
            }
            print("Reachability Summary")
            print("Status:", Network.reachability.status)
            print("HostName:", Network.reachability.hostname ?? "nil")
            print("Reachable:", Network.reachability.isReachable)
            print("Wifi:", Network.reachability.isReachableViaWiFi)
        }
    @objc func statusManager(_ notification: Notification) {
            updateUserInterface()
        }
    
}

