//
//  WeatherViewController.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/02/18.
//

import UIKit
import CoreLocation
/*
 위치 권한 받을때 반드시
 <key>NSLocationWhenInUseUsageDescription</key>
 <string>위치 좀 쓸게?</string>
 */

class WeatherViewController: UIViewController {

    var locationManager:CLLocationManager?
    var currentLocation:CLLocationCoordinate2D!
    

    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestAuthorization()
        getCurrentWeather()
        
    }

    
    private func getCurrentWeather() {
        let weatherView = Bundle.main.loadNibNamed("WeatherView", owner: self, options: nil)?.first as! WeatherView
        weatherView.frame = CGRect(x: 0, y: 0, width: self.scrollView.bounds.width, height: self.scrollView.bounds.height)
        weatherView.currentWeather = CurrentWeather()
        weatherView.currentWeather.getCurrentWeather { (success) in
            weatherView.setupTableView()
            weatherView.setupCollectionView()
            weatherView.setupCurrentWeather()
            self.scrollView.addSubview(weatherView)
        }
    }
    
    private func requestAuthorization() {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
            locationManager!.delegate = self
            locationManagerDidChangeAuthorization(locationManager!)
        }else{
            locationManager!.startMonitoringSignificantLocationChanges()
        }
    }
}

//MARK:ScrollView Delegate
extension WeatherViewController:UIScrollViewDelegate {
    
}

//MARK:CLLocationManager Delegate

extension WeatherViewController:CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            currentLocation = locationManager!.location?.coordinate
            LocationService.shared.longitude = currentLocation.longitude
            LocationService.shared.latitude = currentLocation.latitude
        }
    }
}
