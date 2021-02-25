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
    
    let userDefaults = UserDefaults.standard
    var allLocations:[WeatherLocation] = []
    var allWeatherViews:[WeatherView] = []
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAuthorization()

    }
    
    private func getCurrentWeather(weatherView:WeatherView,location:WeatherLocation) {
        weatherView.currentWeather = CurrentWeather()
        weatherView.currentWeather.getCurrentWeather(location:location) {
            weatherView.setupAll()
        }
    }
    
    private func getHourlyWeather(weatherView:WeatherView,location:WeatherLocation) {
        HourlyWeather.getHourlyWeather(location:location) { (hourlyWeathers) in
            weatherView.hourlyWeathers = hourlyWeathers
            weatherView.hourlyCollectionView.reloadData()
        }
    }
    
    private func getWeeklyWeather(weatherView:WeatherView,location:WeatherLocation) {
        WeeklyWeather.getWeeklyWeather(location:location) { (weeklyWeathers) in
            weatherView.weeklyWeathers = weeklyWeathers
            weatherView.weeklyTableView.reloadData()
        }
    }
    
    private func getWeather() {
          loadLocationFromUserDefaults()
          createWeatherViews()
          addWeatherToScrollView()
          setPageControl()
      }
      
      private func createWeatherViews() {
          for _ in allLocations {
            let weatherView = Bundle.main.loadNibNamed("WeatherView", owner: self, options: nil)?.first as! WeatherView
              allWeatherViews.append(weatherView)
          }
      }
    
    private func addWeatherToScrollView() {
        for i in 0..<allLocations.count {
               let weatherView = allWeatherViews[i]
               let location = allLocations[i]
               
               getCurrentWeather(weatherView: weatherView, location: location)
               getHourlyWeather(weatherView: weatherView, location: location)
               getWeeklyWeather(weatherView: weatherView, location: location)
               
               let xPos = self.view.frame.width * CGFloat(i)
               weatherView.frame = CGRect(x: xPos, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
               scrollView.addSubview(weatherView)
               scrollView.contentSize.width = weatherView.frame.width * CGFloat(i + 1)
           }
       }
    
    private func loadLocationFromUserDefaults() {
           
           let currentLocation = WeatherLocation(city: "", country: "", countryCode: "")
           
           if let data = userDefaults.value(forKey: "Locations") as? Data {
               allLocations = try! PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
               allLocations.insert(currentLocation, at: 0)
               
           }else {
               allLocations.append(currentLocation)
           }
       }
    
    private func setPageControl() {
        pageControl.numberOfPages = allWeatherViews.count
        
    }
    
    private func setPageControlSelectedPage(currentPage:Int) {
        pageControl.currentPage = currentPage
    }
    
    

    
    private func requestAuthorization() {
        if locationManager == nil {
            locationManager = CLLocationManager()
            //정확도를 검사한다.
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            //앱을 사용할때 권한요청
            locationManager!.requestWhenInUseAuthorization()
            locationManager!.delegate = self
        }else{
            //사용자의 위치가 바뀌고 있는지 확인하는 메소드
            locationManager!.startMonitoringSignificantLocationChanges()
        }
    }
}

//MARK:ScrollView Delegate
extension WeatherViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
          let value = scrollView.contentOffset.x/scrollView.frame.size.width
          setPageControlSelectedPage(currentPage: Int(round(value)))
      }
}

//MARK:CLLocationManager Delegate

extension WeatherViewController:CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            currentLocation = locationManager!.location?.coordinate
            LocationService.shared.longitude = currentLocation.longitude
            LocationService.shared.latitude = currentLocation.latitude
            getWeather()
        }
    }
}
