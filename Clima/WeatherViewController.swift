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



class WeatherViewController: UIViewController,CLLocationManagerDelegate,ChangeCityDelegate {
    
   
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "ac60bf70645600a9bd2bc0bd611afd7e"
    
    let locationManager=CLLocationManager()
    let weatherDataModel=WeatherDataModel()
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    //min temp outlets
    @IBOutlet weak var minTempLabel: UILabel!
    //Max temp outlets
    @IBOutlet weak var maxTempLabel: UILabel!
    
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
                let weatherJSON:JSON=JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            }
            else{
                print("Error \(response.result.error!)")
                self.cityLabel.text="Connection Issue"
            }
        }
        
    }

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    func updateWeatherData(json:JSON){
        if let tempResult=json["main"]["temp"].double , let minTempResult=json["main"]["temp_min"].double , let maxTempResult=json["main"]["temp_max"].double{
        weatherDataModel.temperature=Int(tempResult-273.15)
        //Min temp json data
        weatherDataModel.minTemp=Int(minTempResult-273.15)
        weatherDataModel.maxTemp=Int(maxTempResult-273.15)
        
        weatherDataModel.city=json["name"].stringValue
        weatherDataModel.condition=json["weather"][0]["id"].intValue
        weatherDataModel.weatherIconName=weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
        
        
        updateUIWithWeatherData()
        }
        else{
                cityLabel.text="Weather Unavailable"
        }
    }

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData(){
        cityLabel.text=weatherDataModel.city
        temperatureLabel.text="\(weatherDataModel.temperature)°c"
        weatherIcon.image=UIImage(named: weatherDataModel.weatherIconName)
        minTempLabel.text="Min \(weatherDataModel.minTemp)°"
        maxTempLabel.text="Max \(weatherDataModel.maxTemp)°"
        
    }
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location=locations[locations.count-1]
        if location.horizontalAccuracy>0{
            locationManager.stopUpdatingLocation()
            locationManager.delegate=nil
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
    func userEnterACityName(city: String) {
        let params:[String:String]=["q":city,"appid":APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }

    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate=self
        }
    }
    
    
    
    
}


