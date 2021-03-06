//
//  ViewController.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/01/19.
//

import UIKit
import CoreLocation

//시뮬레이터로 돌릴때 Feature - Location - Apple 로 설정하면 오류 없어짐

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var weahterLaction:WeatherLocation!
    
    var locationManager:CLLocationManager?
    var currentLocation:CLLocationCoordinate2D!
    
    let userDefaults = UserDefaults.standard
    
    var allLocations:[WeatherLocation] = []
    var allWeatherViews:[WeatherView] = []
    var allWeatherData:[CityTempData] = []
    
    var shouldRefresh = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManagerStart()
        scrollView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if shouldRefresh {
            allLocations = []
            allWeatherViews = []
            removeViewsFromScrollView()
            locationManagerDidChangeAuthorization(locationManager!)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManagerStop()
    }
    
    
    //MARK:Download Weather
    private func getCurrentWeather(weatherView:WeatherView,location:WeatherLocation) {
        
        weatherView.currentWeather = CurrentWeather()
        weatherView.currentWeather.getCurrentWeather(location: location) { (success) in
        weatherView.refreshData()
            self.generateWeatherList()
        }
    }
    private func getWeeklyWeahter(weatherView:WeatherView,location:WeatherLocation) {
        
        WeeklyForecast.downloadWeeklyForecastWeather(location: location) { (weahterForecasts) in
            weatherView.weeklyWeahterForecastData = weahterForecasts
            weatherView.tableView.reloadData()
        }
        
    }
    private func getHourlyWeather(weatherView:WeatherView,location:WeatherLocation) {
        
        HourlyForecast.downloadHourlyForecastWeather(location: location) { (weatherForecasts) in
            weatherView.dailyWeatherForecastData = weatherForecasts
            weatherView.hourlyWeatherCollectionView.reloadData()
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
            allWeatherViews.append(WeatherView())
        }
    }
    
    //삭제해도 메인에서 살짝보이는거 삭제해주기
    private func removeViewsFromScrollView() {
        for view in scrollView.subviews {
            view.removeFromSuperview()
        }
    }
    
    private func addWeatherToScrollView() {
        for i in 0..<allWeatherViews.count {
            let weatherView = allWeatherViews[i]
            let location = allLocations[i]
            
            getCurrentWeather(weatherView: weatherView, location: location)
            getHourlyWeather(weatherView: weatherView, location: location)
            getWeeklyWeahter(weatherView: weatherView, location: location)
            
            let xPos = self.view.frame.width * CGFloat(i)
            weatherView.frame = CGRect(x: xPos, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
            scrollView.addSubview(weatherView)
            scrollView.contentSize.width = weatherView.frame.width * CGFloat(i + 1)
        }
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
    
    private func setPageControl() {
        pageControl.numberOfPages = allWeatherViews.count
        
    }
    
    private func setPageControlSelectedPage(currentPage:Int) {
        pageControl.currentPage = currentPage
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
    
    //AllLocationView에 보낼 데이터들 세팅
    private func generateWeatherList(){
        allWeatherData = []
        for weatherView in allWeatherViews {
            let tempData = CityTempData(city: weatherView.currentWeather.city, temp: weatherView.currentWeather.currentTemp)
            allWeatherData.append(tempData)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAllLocationTableViewController" {
            let vc = segue.destination as! AllLocationTableViewController
            vc.weatherData = allWeatherData
            vc.delegate = self
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
                getWeather()
            }
        }else{
            print("위치 정보를 설정해주세요!")
        }
    }
}

extension WeatherViewController:UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x/scrollView.frame.size.width
        setPageControlSelectedPage(currentPage: Int(round(value)))
    }
}

extension WeatherViewController:AllLocationTableViewControllerDelegate {
    //AllLocationViewContrller에서 특정 도시를 선택하고 돌아오면 해당 도시의 스크롤뷰 위치를 알아내서 리프레쉬한다.
    func didChooseLocation(atIndex: Int, shouldRefresh: Bool) {
        let viewNumber = CGFloat(integerLiteral: atIndex)
        let newOffset = CGPoint(x: (scrollView.frame.width + 1) * viewNumber, y: 0)
        scrollView.setContentOffset(newOffset, animated: true)
        setPageControlSelectedPage(currentPage: atIndex)
        
        self.shouldRefresh = shouldRefresh
    }
}
