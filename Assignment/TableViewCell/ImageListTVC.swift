//
//  ImageListTVC.swift
//  Assignment
//
//  Created by Ravi Singh on 15/09/23.
//

import UIKit

class ImageListTVC: UITableViewCell {
    
    @IBOutlet weak var dummyImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    static let nibName = "ImageListTVC"
    static let reuseIdentifier = "ImageListTVC"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
