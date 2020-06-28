//
//  TextPostTableViewCell.swift
//  Birdie-Final
//
//  Created by Maitri Mehta on 6/27/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class TextPostTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var textBodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
