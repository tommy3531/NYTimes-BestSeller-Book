//
//  CategoryTableViewCell.swift
//  NYT Best Books
//
//  Created by Vinit Jasoliya on 9/27/16.
//  Copyright © 2016 ViNiT. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
