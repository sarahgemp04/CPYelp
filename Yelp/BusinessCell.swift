//
//  BusinessCell.swift
//  Yelp
//
//  Created by Sarah Gemperle on 1/20/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dollarLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var business: Business! {
        didSet {
            titleLabel.text = business!.name
            thumbImageView.setImageWith((business.imageURL)!)
            kindLabel.text = business.categories!
            addressLabel.text = business.address
            reviewsLabel.text = "\(business.reviewCount!) Reviews"
            ratingImageView.setImageWith((business.ratingImageURL)!)
            distanceLabel.text = business.distance!
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        thumbImageView.layer.cornerRadius = 5
        thumbImageView.clipsToBounds = true
        
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.size.width
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.size.width
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
