//
//  VT.swift
//  chamcong
//
//  Created by Quang Linh on 24/03/2024.
//

import UIKit

class VT: UITableViewCell {
    
    @IBOutlet weak var STT: UILabel!
    
    @IBOutlet weak var view: UIStackView!
    @IBOutlet weak var Vido: UILabel!
    @IBOutlet weak var Kinhdo: UILabel!
    @IBOutlet weak var Tenvt: UILabel!
    @IBOutlet weak var Mavt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

