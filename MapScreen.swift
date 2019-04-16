//
//  MapScreen.swift
//  InstaAid
//
//  Created by Rishi Anand on 3/8/19.
//  Copyright © 2019 Rishi Anand. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapScreen: UIViewController {
    
@IBOutlet weak var MapScreen: MKMapView!
@IBOutlet weak var addressLabel: UILabel!
@IBOutlet weak var goButtonTapped: UIButton!
    
//Declerations of Variables + Let Statements
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var previousLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as? CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
        }
        
        
        
        
//Privacy Code Below
        
        func checkLocationAuthorization() {
            switch CLLocationManager.authorizationStatus() {
            case.authorizedWhenInUse:
                centerViewOnUserLocation()
                locationManager.startUpdatingLocation()
                previousLocation = getCenterLocation(for: MapScreen)
                break
            case.denied:
                break
            //Show alert letting them know what is up
            case.notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case.restricted:
                break
            //Show alert letting them know what is up
            case.authorizedAlways:
                break
            }
        }
        
    
        
        
        
        func checkLocationServices() {
            if CLLocationManager.locationServicesEnabled() {
                setupLocationManager()
                checkLocationAuthorization()
            } else {
                //Create an alert to let them know what is up
            }
        }
        
        
        
//Location Code Below
        
        func setupLocationManager() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }

    
        func centerViewOnUserLocation() {
            if let location = locationManager.location?.coordinate {
            let reigon = MKCoordinateRegion.init(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
            MapScreen.setRegion(reigon, animated: true)
            }
        }
    }
}


        func getCenterLocation(for mapView: MKMapView) -> CLLocation{
            let latitude = mapView.centerCoordinate.latitude
            let longitude = mapView.centerCoordinate.longitude
            
            return CLLocation(latitude: latitude, longitude: longitude)
        }
    







//Extensions below
extension MapScreen:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
         checkLocationAuthorization()
    }
}



extension MapScreen: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool){
        let center = getCenterLocation (for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else {return}
            
            if let _ = error {
                return
            }
            
            guard let placemark = placemarks?.first else {
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            DispatchQueue.main.async {
                self.addressLabel.text = "\(streetNumber) \(streetName)"
            }
        }
    }
}





//Websockets Node.js below






