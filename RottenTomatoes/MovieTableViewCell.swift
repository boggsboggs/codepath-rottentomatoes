//
//  MovieTableViewCell.swift
//  RottenTomatoes
//
//  Created by Nidhi Kulkarni on 2/8/15.
//  Copyright (c) 2015 John Boggs. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var movieImageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieText: UILabel!

    var movie: Dictionary<String, AnyObject> = Dictionary() {
        didSet {
            self.titleLabel.text = movie["title"]! as? String
            self.movieText.text = movie["synopsis"]! as? String
            let thumbnailUrl = (movie["posters"]! as Dictionary)["thumbnail"]! as String
            self.movieImageView.setImageWithURL(NSURL.URLWithString(thumbnailUrl))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
