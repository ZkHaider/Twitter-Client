//
//  MenuCellTableViewCell.swift
//  Twitter-Client
//
//  Created by Haider Khan on 11/7/16.
//  Copyright © 2016 ZkHaider. All rights reserved.
//

import UIKit

class MenuCellTableViewCell: UITableViewCell {

    @IBOutlet weak var itemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
