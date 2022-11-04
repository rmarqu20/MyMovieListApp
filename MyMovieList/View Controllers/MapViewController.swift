//
//  MapViewController.swift
//  MyMovieList
//
//  Created by Richard Marquez on 3/20/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var theatreCountLabel: UILabel!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var mapTable: UITableView!
    var testArray = ["test1", "test2", "test3"]
    var theatreList = [MKMapItem]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mapTable.rowHeight = 100
        self.mapTable.reloadData()
    }
    
    func getRegion()
    {
        //Code taken from Geo Coding lecture
        let geoCoder = CLGeocoder()
        var addressString = cityField.text //user location
        if addressString == ""
        {
            //Tempe for default city/location
            addressString = "Tempe"
        }
        print("TEST1: \(addressString)")
        CLGeocoder().geocodeAddressString(addressString!, completionHandler:
            {(placemarks, error) in
            if(error != nil)
            {
                print("Geocode failed: \(error!.localizedDescription)")
            }
            else
            {
                let placemark = placemarks![0]
                let location = placemark.location
                let coords = location!.coordinate
                print("TEST2")
                print(location)
                
                let span = MKCoordinateSpan.init(latitudeDelta: 0.075, longitudeDelta: 0.075)
                let region = MKCoordinateRegion(center: placemark.location!.coordinate, span: span)
                self.map.setRegion(region, animated: true)
            }
            print("TEST3")
        })
    }
    
    func getSearch()
    {
        //Remove old annotations before adding new ones
        let allAnnotations = map.annotations
        map.removeAnnotations(allAnnotations)
        self.theatreList = []
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "movie"
        var searchRegion = map.region
        searchRegion.span.latitudeDelta = 0.01
        searchRegion.span.longitudeDelta = 0.01
        request.region = searchRegion
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
            guard let response = response
            else
            {
                return
            }
            print(response.mapItems)
            var matchingItems:[MKMapItem] = []
            matchingItems = response.mapItems
            self.theatreList = matchingItems
            self.mapTable.reloadData()
            for i in 1...matchingItems.count - 1
            {
                let place = matchingItems[i].placemark
                //Instead of printing, create annotations and add to map
                let ani2 = MKPointAnnotation()
                ani2.coordinate = place.location!.coordinate
                ani2.title = matchingItems[i].name
                ani2.subtitle = place.subLocality
                
                self.map.addAnnotation(ani2)
            }
        }
    }
    
    @IBAction func searchArea(_ sender: Any)
    {
        getRegion()
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds)
        {
            self.getSearch()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("Theatre Count: \(theatreList.count)")
        theatreCountLabel.text = "\(theatreList.count)"
        return theatreList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = mapTable.dequeueReusableCell( withIdentifier: "mapCell", for: indexPath) as! MapTableViewCell
        cell.layer.borderWidth = 0.3
        
        cell.theatreNameLabel.text = theatreList[indexPath.row].name ?? "NA"
        cell.theatreDistanceLabel.text = "Phone Number: \(theatreList[indexPath.row].phoneNumber ?? "NA")"
        return cell
    }
    
}
