//
//  MyChatTVCell.swift
//  TradingBot
//
//  Created by TradeSocio on 31/05/19.
//  Copyright © 2019 Tradesocio. All rights reserved.
//

import UIKit

class MyChatTVCell: UITableViewCell {

    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var lblMsg: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewParent.layer.borderColor = UIColor.black.cgColor
        viewParent.layer.borderWidth = 1.0
        viewParent.layer.cornerRadius = viewParent.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
