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
        setupWeatherView()
    }
    
    private func setupWeatherView() {
        let weatherView = Bundle.main.loadNibNamed("WeatherView", owner: self, options: nil)?.first as! WeatherView
        weatherView.frame = CGRect(x: 0, y: 0, width: self.scrollView.bounds.width, height: self.scrollView.bounds.height)
        getCurrentWeather(weatherView: weatherView)
        getHourlyWeather(weatherView: weatherView)
        self.scrollView.addSubview(weatherView)
        
    }
    
    
    private func getCurrentWeather(weatherView:WeatherView) {
        weatherView.currentWeather = CurrentWeather()
        weatherView.currentWeather.getCurrentWeather {
            weatherView.setupAll()
        }
    }
    
    private func getHourlyWeather(weatherView:WeatherView) {
        HourlyWeather.getHourlyWeather { (hourlyWeathers) in
            weatherView.hourlyWeathers = hourlyWeathers
            weatherView.hourlyCollectionView.reloadData()
        }
    }
    
    

    
    private func requestAuthorization() {
        if locationManager == nil {
            locationManager = CLLocationManager()
            //정확도를 검사한다.
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            //앱을 사용할때 권한요청
            locationManager!.requestWhenInUseAuthorization()
            locationManager!.delegate = self
            locationManagerDidChangeAuthorization(locationManager!)
        }else{
            //사용자의 위치가 바뀌고 있는지 확인하는 메소드
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
