//
//  ViewController.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/01/19.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var weahterLaction:WeatherLocation!
    
    var locationManager:CLLocationManager?
    var currentLocation:CLLocationCoordinate2D!
    
    let userDefaults = UserDefaults.standard
    
    var allLocations:[WeatherLocation] = []
    var allWeatherView:[WeatherView] = []
    var allWeatherData:[CityTempData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManagerStart()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        let weatherView = WeatherView()
//        weatherView.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
//        scrollView.addSubview(weatherView)
//
//        weahterLaction = WeatherLocation(city: "Incheon", country: "Korea", countryCode: "KR", isCurrentLocation: false)
//
//        getCurrentWeather(weatherView: weatherView)
//        getWeeklyWeahter(weatherView: weatherView)
//        getHourlyWeather(weatherView: weatherView)
    }
    
    
    //MARK:Download Weather
    private func getCurrentWeather(weatherView:WeatherView) {
        
        weatherView.currentWeather = CurrentWeather()
        weatherView.currentWeather.getCurrentWeather(location: weahterLaction) { (success) in
        weatherView.refreshData()
            
        }
    }
    private func getWeeklyWeahter(weatherView:WeatherView) {
        
        WeeklyForecast.downloadWeeklyForecastWeather(location: weahterLaction) { (weahterForecasts) in
            weatherView.weeklyWeahterForecastData = weahterForecasts
            weatherView.tableView.reloadData()
        }
        
    }
    private func getHourlyWeather(weatherView:WeatherView) {
        
        HourlyForecast.downloadHourlyForecastWeather(location: weahterLaction) { (weatherForecasts) in
            weatherView.dailyWeatherForecastData = weatherForecasts
            weatherView.hourlyWeatherCollectionView.reloadData()
        }
    }
    
    private func getWeather() {
        loadLocationFromUserDefaults()
    }
    
    private func loadLocationFromUserDefaults() {
        
        let currentLocation = WeatherLocation(city: "", country: "", countryCode: "", isCurrentLocation: true)
        
        if let data = userDefaults.value(forKey: "Locations") as? Data {
            allLocations = try! PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
            
            allLocations.insert(currentLocation, at: 0)
            
        }else {
            allLocations.append(currentLocation)
        }
        
    }
    
    private func locationManagerStart() {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            //유저 권한 물어보기
            locationManager!.requestWhenInUseAuthorization()
            locationManager!.delegate = self
        }
        //위치가 바뀌는지 감지하기
            locationManager!.startMonitoringSignificantLocationChanges()
    }
    
    private func locationManagerStop() {
        if locationManager != nil {
            locationManager!.stopMonitoringSignificantLocationChanges()
        }
    }
    
  
}

extension WeatherViewController:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            currentLocation = locationManager!.location?.coordinate
            if currentLocation != nil {
                LocationService.shared.latitude = currentLocation.latitude
                LocationService.shared.longitude = currentLocation.longitude
                getWeather()
                
            }else{
                locationManagerDidChangeAuthorization(manager) 
            }
        }else{
            print("위치 정보를 설정해주세요!")
        }
    }
}
