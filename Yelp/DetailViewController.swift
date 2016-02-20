//
//  DetailViewController.swift
//  Yelp
//
//  Created by Gale on 2/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var business: Business!;
    var data: NSDictionary?;

    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var ratingsImageView: UIImageView!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        businessNameLabel.text = business.name
        distanceLabel.text = business.distance
        //ratingsLabel.text = business.reviewCount as! String
        categoriesLabel.text = business.categories

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
