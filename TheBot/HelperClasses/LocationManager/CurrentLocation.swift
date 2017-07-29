//
//  CurrentLocation.swift
//  TheBot
//
//  Created by Daman on 27/07/17.
//  Copyright © 2017 Tarsem. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift

typealias LocationCompletionBlock = (_ response: CLLocation?, _ error: String?) -> Void

class CurrentLocation: NSObject, CLLocationManagerDelegate {

    static let sharedInstance = CurrentLocation()
    var locationManager:CLLocationManager!
    var locationCompletionBlock:LocationCompletionBlock!
    var myLocationArray:[GeoPoint] = []
    var bestLocation:CLLocation?
    var updatedAt:Date?
    var timer:Timer?

    class func getCurentLocation(_ update:Bool, completion: LocationCompletionBlock?){
        let selfObj = CurrentLocation.sharedInstance
        selfObj.locationCompletionBlock = completion
        if selfObj.locationManager == nil || selfObj.bestLocation == nil {
            selfObj.locationInitializer()
        }
        else if(update){
            selfObj.updateCurrentLocation()
        }
        else if completion != nil{
            completion!(selfObj.bestLocation, nil)
        }
    }
    
    func updateCurrentLocation(){
        if (self.locationManager == nil) {
            locationInitializer()
        }
        else if(bestLocation == nil || (self.updatedAt != nil && Date().timeIntervalSince(self.updatedAt!) > 30)){
            print("start updating location called")
            locationManager.startUpdatingLocation()
        }
        else{
            if(locationCompletionBlock != nil){
                locationCompletionBlock!(bestLocation, nil)
                locationCompletionBlock = nil
            }
        }
    }
    
    func locationInitializer(){
        if (CLLocationManager.locationServicesEnabled() == false) {
            if locationCompletionBlock != nil{
                locationCompletionBlock!(nil, "You currently have all location services for this device disabled")
                locationCompletionBlock = nil
            }
            return
        }
        
        locationManager = CLLocationManager.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        locationManager.requestWhenInUseAuthorization()
        let status:CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        switch (status) {
        case .authorizedAlways,.authorizedWhenInUse:
            print("start updating location called 2")
            locationManager.startUpdatingLocation()
            break;
            
        case .denied,.restricted:
            if locationCompletionBlock != nil{
                locationCompletionBlock!(nil, "Re-launch the application again, after turning on Location Service for this app to update your current location.")
                locationCompletionBlock = nil
            }

        break;
            
            
        default:
            break;
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("start updating location called 3")
            locationManager.startUpdatingLocation()
        }
    }
    
    var updateCalled = false
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for i in 0..<locations.count{
            
            let newLocation:CLLocation = locations[i]
            let theLocation:CLLocationCoordinate2D = newLocation.coordinate;
            let theAccuracy:CLLocationAccuracy = newLocation.horizontalAccuracy;
        
            if(theAccuracy>0 && theAccuracy < 2000 && (!(theLocation.latitude == 0.0 && theLocation.longitude == 0.0))){
                
                let geoPoint:GeoPoint = GeoPoint.init()
                geoPoint.latitude = theLocation.latitude
                geoPoint.longitude = theLocation.longitude
                geoPoint.accuracy = theAccuracy
                
                myLocationArray.append(geoPoint)
               
                
                if (self.bestLocation == nil) {
                    self.bestLocation = newLocation;
                }
            }
        }
        
        if(updateCalled){
            return
        }
        
        self.perform(#selector(stopLocationUpdation), with: nil, afterDelay: 5)
        updateCalled = true

    }

func stopLocationUpdation(){
    locationManager.stopUpdatingLocation()
    if locationCompletionBlock != nil{
        locationCompletionBlock!(bestLocation, nil)
        locationCompletionBlock = nil
    }
    
    }
    
func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    locationManager.stopUpdatingLocation()
    if locationCompletionBlock != nil{
        locationCompletionBlock!(bestLocation, error.localizedDescription)
        locationCompletionBlock = nil
    }
}
    

func updateLocationData(){
        
        //NSLog(@"updateLocationToServer");
        
        // Find the best location from the array based on accuracy
    var myBestLocation:GeoPoint?
    
        for i in 0 ..< self.myLocationArray.count{
            let currentLocation = self.myLocationArray[i]
            if(i == 0){
                myBestLocation = currentLocation;
            }
            else{
                if(currentLocation.accuracy <= myBestLocation!.accuracy){
                    myBestLocation = currentLocation;
                }
            }
        }
        // NSLog(@"My Best location:%@",myBestLocation);
        
        //If the array is 0, get the last location
        //Sometimes due to network issue or unknown reason, you could not get the location during that  period, the best you can do is sending the last known location to the server
    if myBestLocation != nil{
        bestLocation = CLLocation.init(latitude: myBestLocation!.latitude, longitude: myBestLocation!.longitude)
        updatedAt = Date()
    }

    myLocationArray = []
}

    
class func getAddressAtLocation(_ currentLocation:CLLocation, success:@escaping (_ address: String?) -> Void){
    let geoCoder = CLGeocoder.init()
    geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
        
        var addressArr:[String] = [];
        
        if (error == nil && (placemarks?.count ?? 0) > 0)
        {
            let placemark:CLPlacemark = (placemarks?.last)!
            if (placemark.subThoroughfare != nil){
                addressArr.append(placemark.subThoroughfare!)
            }
            
            if (placemark.subThoroughfare != nil){
                addressArr.append(placemark.subThoroughfare!)
            }
            
            if (placemark.postalCode != nil){
                addressArr.append(placemark.postalCode!)
            }
            
            if (placemark.locality != nil){
                addressArr.append(placemark.locality!)
            }
            
            if (placemark.administrativeArea != nil){
                addressArr.append(placemark.administrativeArea!)
            }
            
            if (placemark.country != nil){
                addressArr.append(placemark.country!)
            }
        }
        success(addressArr.joined(separator: ", "));
        
    }
}

}
