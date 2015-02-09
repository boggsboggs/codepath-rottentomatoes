//
//  MovieDetailViewController.swift
//  RottenTomatoes
//
//  Created by Nidhi Kulkarni on 2/8/15.
//  Copyright (c) 2015 John Boggs. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var backgroundImage: UIImageView!

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieText: UILabel!
    var movie: Dictionary<String, AnyObject> = Dictionary() {
        didSet {

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = movie["title"]! as? String
        self.title = title
        self.movieTitle.text = title
        self.movieText.text = movie["synopsis"]! as? String
        let thumbnailUrl = (movie["posters"]! as Dictionary)["thumbnail"]! as String
        let qualityImageUrl = thumbnailUrl.stringByReplacingOccurrencesOfString(
            "_tmb.jpg", withString: "_ori.jpg", options: NSStringCompareOptions.LiteralSearch, range: nil)
        self.backgroundImage.setImageWithURL(NSURL.URLWithString(thumbnailUrl))
        self.backgroundImage.setImageWithURL(NSURL.URLWithString(qualityImageUrl))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
