//
//  MainTableViewCell.swift
//  NYT Best Books
//
//  Created by Vinit Jasoliya on 9/27/16.
//  Copyright © 2016 ViNiT. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var titleLabelHieght: NSLayoutConstraint!
    @IBOutlet weak var ranksLabel: UILabel!
    @IBOutlet weak var ranksValue: UILabel!
    @IBOutlet weak var authorLabelHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
