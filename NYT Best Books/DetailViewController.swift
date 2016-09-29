//
//  DetailViewController.swift
//  NYT Best Books
//
//  Created by Vinit Jasoliya on 9/27/16.
//  Copyright © 2016 ViNiT. All rights reserved.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var amazonButtonOutlet: UIButton!
    @IBOutlet weak var nytButtonOutlet: UIButton!
    @IBOutlet weak var rankLabel: UILabel!

    //extra parent screen passed variables
    var booksTitle = ""
    var booksAuthor = ""
    var booksDescription = ""
    var booksImage = ""
    var amazonLink = ""
    var nytLink = ""
    var bookRanks = ""
    var bookCategory = ""
    
    //MARK: - View Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadImage()
        
        titleLabel.text = booksTitle
        titleLabelHeightConstraint.constant = heightForView(text: "\(booksTitle)", font: UIFont(name: "Times New Roman", size: 30.0)!, width: self.view.bounds.size.width - 32.0)
        if bookCategory.isEmpty {
            authorLabel.text = "by \(booksAuthor)"
        } else {
            authorLabel.text = "by \(booksAuthor) \nin \(bookCategory)"
        }
        if booksDescription.isEmpty {
            descLabel.text = "No description available."
        } else {
            descLabel.text = "Description: \(booksDescription)"
        }
        let descHeightCheck = heightForView(text: "\(booksDescription)", font: UIFont(name: "Times New Roman", size: 15.0)!, width: self.view.bounds.size.width - 32.0)
        
        if descHeightCheck > 115.0 {
            descriptionLabelHeight.constant = descHeightCheck
        } else {
            descriptionLabelHeight.constant = 100.0
        }
        
        if amazonLink.isEmpty {
            amazonButtonOutlet.isHidden = true
        } else {
            amazonButtonOutlet.isHidden = false
        }
        if nytLink.isEmpty {
            nytButtonOutlet.isHidden = true
        } else {
            nytButtonOutlet.isHidden = false
        }
        
        rankLabel.text = bookRanks
        rankLabel.layer.backgroundColor = UIColor.black.cgColor
        rankLabel.layer.cornerRadius = 16.0
        rankLabel.textColor = UIColor.white
        if bookRanks == "0" {
            rankLabel.isHidden = true
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Loading Image
    func loadImage() {
        
        bookImage.kf.indicatorType = .activity
        bgImage.kf.setImage(with: URL(string: "\(booksImage)"), placeholder: UIImage(named:"No_Image_Available"), options: [.transition(.fade(0.2))])
        bookImage.kf.setImage(with: URL(string: "\(booksImage)"), placeholder: UIImage(named:"No_Image_Available"), options: [.transition(.fade(0.2))])
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bgImage.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
     //   blurEffectView.alpha = 0.85
        bgImage.addSubview(blurEffectView)
        bookImage.layer.shadowPath = UIBezierPath(rect: bookImage.bounds).cgPath
        bookImage.layer.shouldRasterize = true
    }
    
    //Calculates run-time height of a UILabel
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x:0,y: 0,width: width,height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    //MARK: - IBAction button functions
    @IBAction func amazonButtonPressed(_ sender: AnyObject) {
        
        let url = URL(string: amazonLink)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    
    }
    
    @IBAction func nytimesButtonPressed(_ sender: AnyObject) {
        
        let url = URL(string: nytLink)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}

@IBDesignable class TopAlignedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        if let stringText = text {
            let stringTextAsNSString = stringText as NSString
            let labelStringSize = stringTextAsNSString.boundingRect(with: CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude),
                                                                            options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                            attributes: [NSFontAttributeName: font],
                                                                            context: nil).size
            super.drawText(in: CGRect(x: 0,y: 0,width: self.frame.width,height: ceil(labelStringSize.height)))
        } else {
            super.drawText(in: rect)
        }
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
}
