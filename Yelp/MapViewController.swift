//
//  MapViewController.swift
//  Yelp
//
//  Created by Gale on 2/19/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var businesses: [Business]!
    
    var locationManager : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adding location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()

        // Do any additional setup after loading the view.
        
        // Getting all the restaurants and placing pins based on longitude and latitude
        Business.searchWithTerm("restaurants", latitude: locationManager.location?.coordinate.latitude, longitude: locationManager.location?.coordinate.longitude, sort: .Distance, categories: [], deals: false, offset: nil, limit: 20) { (businesses: [Business]!, error: NSError!) -> Void in
                self.businesses = businesses
                for business in businesses {
                    let pinLocation = CLLocationCoordinate2DMake(business.latitude! as Double!, business.longitude as Double!)
                    self.addAnnotationAtCoordinate(pinLocation, title: business.name!)
                }
            }
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Getting permissions for users location
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    
    // Focusing on a specific region
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            region.center
            mapView.setRegion(region, animated: false)
        }
    }
    
    // Function that adds annotations to the pins
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D, title: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
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
