//
//  MainMenuCell.swift
//  VSCO
//
//  Created by Fatih Oğuz on 20.07.2024.
//

import UIKit

class MainMenuCell: UITableViewCell {

    @IBOutlet weak var feedUserNameLabel: UILabel!
    
    @IBOutlet weak var feedImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
