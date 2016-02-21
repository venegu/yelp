//
//  DetailViewController.swift
//  Yelp
//
//  Created by Gale on 2/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var business: Business!
    var data: NSDictionary?

    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var ratingsImageView: UIImageView!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressSecLabel: UILabel!
    @IBOutlet weak var addressThreeLabel: UILabel!

    @IBOutlet weak var detailsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressLabel.text = ""
        addressSecLabel.text = ""
        addressThreeLabel.text = ""
        businessNameLabel.text = business.name
        distanceLabel.text = business.distance
        categoriesLabel.text = business.categories
        
        // To get further details about business
        YelpClient.sharedInstance.getBusiness(business.id!, completion: { (data: NSDictionary!, error: NSError!) -> Void in
            self.data = data
            
            let url = data!["image_url"] as! String
            self.businessImageView.setImageWithURL(NSURL(string: url)!)
            self.ratingsImageView.setImageWithURL(NSURL(string: data!["rating_img_url"] as! String)!)
            self.ratingsLabel.text = "\(data!["review_count"]!) Ratings"
            
            var categories: [String] = []
            for category in data!["categories"] as! [[String]] {
                categories.append(category[0])
            }
            self.categoriesLabel.text = categories.joinWithSeparator(", ")
            
            var addresses: [String] = data!["location"]!["display_address"]!! as! [String]
            self.addressLabel.text = addresses[0]
            self.addressSecLabel.text = addresses[1]
            self.addressThreeLabel.text = addresses[2]

        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
