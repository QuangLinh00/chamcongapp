//
//  ChamCong.swift
//  chamcong
//
//  Created by Quang Linh on 21/05/2024.
//

import UIKit

class ChamCong: UITableViewCell {
    
    
    @IBOutlet weak var MaNV: UILabel!
    @IBOutlet weak var GioChamCong: UILabel!
    @IBOutlet weak var NgayChamCong: UILabel!
    @IBOutlet weak var MaVT: UILabel!
    
    @IBOutlet weak var View: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
