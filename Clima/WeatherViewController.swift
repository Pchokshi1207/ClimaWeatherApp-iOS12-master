//
//  ViewController.swift
//  WeatherApp
//
//  Created by Pankti Chokshi on 04/19/2019.
//  Copyright (c) PC. All rights reserved.

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON



class WeatherViewController: UIViewController,CLLocationManagerDelegate {
    
   
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "ac60bf70645600a9bd2bc0bd611afd7e"
    
    let locationManager=CLLocationManager()
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.delegate=self
        locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    
        
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData(url:String,parameters:[String:String]){
        Alamofire.request(url,method:.get,parameters: parameters).responseJSON{
            response in
            if response.result.isSuccess {
                print("Got the weather data")
            }
            else{
                print("Error \(response.result.error)")
                self.cityLabel.text="Connection Issue"
            }
        }
        
    }

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location=locations[locations.count-1]
        if location.horizontalAccuracy>0{
            locationManager.startUpdatingLocation()
            print("longitude=\(location.coordinate.longitude),latitude=\(location.coordinate.latitude)")
            let latitude=String(location.coordinate.latitude)
            let longitude=String(location.coordinate.longitude)
            let params:[String:String]=["lat":latitude,"lon":longitude,"appid":APP_ID]
            getWeatherData(url:WEATHER_URL,parameters:params)
        }
        
    }
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text="Location Unavailable"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    

    
    //Write the PrepareForSegue Method here
    
    
    
    
    
}


