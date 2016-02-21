//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate, FiltersViewControllerDelegate {

    var businesses: [Business]!
    var filteredBusinesses: [Business]!
    
    var searchBar : UISearchBar!
    
    // Declaring variables pertaining to infinite scrolling
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    var offset: Int? = 20
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creating search bar
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Enter a business name"
        
        // Adding search bar to the navigation as a navigation item
        navigationItem.titleView = searchBar
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Specifying table view row height based on auto layout constraints
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // To speed things up when opening the app - dynamic cell heights take time to calculate
        tableView.estimatedRowHeight = 110

        Business.searchWithTerm("Restaurant", latitude: 37.721839, longitude: -122.476927, sort: .Distance, categories: [], deals: false, offset: nil, limit: 20, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            //self.filteredBusinesses = self.businesses
            self.tableView.reloadData()
        })

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurant", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            if (self.businesses != nil) {
                self.filteredBusinesses = self.businesses
                self.tableView.reloadData()
            }
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
        // Adding loading view as an inset to the table view for infinite scrolling
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Checking if the user scrolled, making the request/view and starting the load indicator
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                loadMoreData()		
            }
        }
    }
    
    /**********
     Table View
    ***********/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if businesses != nil {
            return businesses!.count
        } else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        cell.accessoryType = UITableViewCellAccessoryType.None
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    

    
    /**********
     Search Bar
    ***********/
    
    // Searching for items related to search and displaying those
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        Business.searchWithTerm(searchText, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            self.filteredBusinesses = self.businesses
            self.tableView.reloadData()

        })
    }
    
    // Displaying cancel button
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    // Returning intial data back to table view & resigning first responder when cancel is clicked
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredBusinesses = businesses
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        
    }
    
    // Getting more data 
    func loadMoreData() {
            //Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurant", latitude: 37.721839, longitude: -122.476927, sort: .Distance, categories: [], deals: false, offset: offset, limit:20) { (businesses: [Business]!, error: NSError!) -> Void in
            
                // Stop the loading indicator
            self.loadingMoreView!.stopAnimating()
            
            if (businesses != []) {
                for business in businesses {
                    self.businesses.append(business)
                }
                self.filteredBusinesses = self.businesses
                self.tableView.reloadData()
                self.offset! = self.offset! + 20
            }
            // Update flag
            self.isMoreDataLoading = false
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toDetails" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let business = businesses[indexPath!.row]
        
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.business = business
        }
        
        let navigationController = segue.destinationViewController as! UINavigationController
        
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
        
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        var categories = filters["categories"] as? [String]
        print("categories: \(categories)")
        
        Business.searchWithTerm("Restaurants", latitude: 37.721839, longitude: -122.476927, sort: nil, categories: categories, deals: nil, offset: offset, limit:20) { ( businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }


}

// Infinite Scroll Class
class InfiniteScrollActivityView: UIView {
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    static let defaultHeight:CGFloat = 60.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupActivityIndicator()
    }
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
        setupActivityIndicator()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
    }
    
    func setupActivityIndicator() {
        activityIndicatorView.activityIndicatorViewStyle = .Gray
        activityIndicatorView.hidesWhenStopped = true
        self.addSubview(activityIndicatorView)
    }
    
    func stopAnimating() {
        self.activityIndicatorView.stopAnimating()
        self.hidden = true
    }
    
    func startAnimating() {
        self.hidden = false
        self.activityIndicatorView.startAnimating()
    }
}
