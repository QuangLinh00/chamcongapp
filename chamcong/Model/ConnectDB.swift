//
//  ConnectDB.swift
//  chamcong
//
//  Created by Quang Linh on 17/03/2024.
//

import UIKit

class ConnectDB: NSObject {
    let client = SQLClient.sharedInstance()!


    func initConnect(onSuccess: @escaping ((Any)->Void)) {
        client.connect("115.79.198.245:1459", username: "AP", password: "AP@2018TPS@", database: "KHO"){ success in
            print("115.79.198.245,1459===dbb==\(success)")
            onSuccess(success)
        }
    }
    
    
    func disConnect(){
        self.client.disconnect()
    }
    
    func convertStr(results: [Any?]!, name: String) -> String {
        var value = ""
        // Kiểm tra xem đối số results có khác nil không
        guard let resultsArray = results.first as? [NSDictionary] else{
            value = "Không thể chuyển đổi kết quả thành một mảng của NSDictionary"
            return value
        }
        
        
        if let firstResult = resultsArray.first, let nameValue = firstResult[name] as? String {
            value = nameValue
            
        } else {
            value = "Không thể truy xuất giá trị của trường \(name)"
            
        }
        return value
    }


}
