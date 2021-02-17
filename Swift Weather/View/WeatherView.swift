//
//  WeatherView.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/01/27.
//

import UIKit



class WeatherView: UIView {

    //MARK:IBOutlets
    @IBOutlet weak var weatherInfoLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var hourlyWeatherCollectionView: UICollectionView!
    @IBOutlet weak var infoCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
    var currentWeather:CurrentWeather!
    var weeklyWeahterForecastData:[WeeklyForecast] = []
    var dailyWeatherForecastData:[HourlyForecast] = []
    var weatherInfoData:[WeatherInfo] = []
    
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        mainInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func mainInit() {
        
        Bundle.main.loadNibNamed("WeatherView", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        setUpTableView()
        sepUpHourlyCollectionView()
        setUpInfoCollectionVIew()
    }
    
    private func setUpTableView() {
        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "Cell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
    }
    private func sepUpHourlyCollectionView() {
        
        hourlyWeatherCollectionView.register(UINib(nibName: "ForecastCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "Cell")
        hourlyWeatherCollectionView.dataSource = self

    }
    private func setUpInfoCollectionVIew() {
        
        infoCollectionView.register(UINib(nibName: "InfoCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "Cell")
        infoCollectionView.dataSource = self
        
    }
    
    func refreshData() {
        setUpCurrentWeather()
        setUpInfo()
        infoCollectionView.reloadData()
    }
    
    
    private func setUpCurrentWeather() {
        cityLabel.text = currentWeather.city
        dateLabel.text = "Today, \(currentWeather.date.shortDate())"
        weatherInfoLabel.text = currentWeather.weatherType
        temperatureLabel.text = String(format: "%.0f%@", currentWeather.currentTemp,returnTempFormatFromUserDefaults())
     
        
    }
    
    private func setUpInfo() {
        
        let wind = WeatherInfo(infoText: String(format: "%.1f m/sec", currentWeather.windSpeed) , nameText: nil, image: getWeatherIconFor("wind"))
        let humidity = WeatherInfo(infoText: String(format: "%.0f ", currentWeather.humidity), nameText: nil, image: getWeatherIconFor("humidity"))
        let pressure = WeatherInfo(infoText: String(format: "%.0f mb", currentWeather.pressure), nameText: nil, image: getWeatherIconFor("pressure"))
        let sunset = WeatherInfo(infoText: currentWeather.sunset, nameText: nil, image: getWeatherIconFor("sunset"))
        let sunrise = WeatherInfo(infoText: currentWeather.sunrise, nameText: nil, image: getWeatherIconFor("sunrise"))
        let uv = WeatherInfo(infoText: String(format: "%.1f", currentWeather.uv), nameText: "UV Index", image: nil)
        let visibility = WeatherInfo(infoText: String(format: "%.0f km", currentWeather.visibility), nameText: nil, image: getWeatherIconFor("visibility"))
        let feelsLike = WeatherInfo(infoText: String(format: "%.1f", currentWeather.feelsLike), nameText: nil, image: getWeatherIconFor("feelsLike"))
        
        weatherInfoData = [wind,humidity,pressure,sunset,sunrise,uv,visibility,feelsLike]
        
    }
    
}

extension WeatherView :UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyWeahterForecastData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WeatherTableViewCell
        cell.generateCell(forecast: weeklyWeahterForecastData[indexPath.row])
        return cell
    }
    
}

extension WeatherView:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        return collectionView == hourlyWeatherCollectionView  ? dailyWeatherForecastData.count : weatherInfoData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == hourlyWeatherCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ForecastCollectionViewCell
            cell.generateCell(weather: dailyWeatherForecastData[indexPath.item])
            
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! InfoCollectionViewCell
            cell.generateCell(weatherInfo: weatherInfoData[indexPath.item])
            return cell
        }
    }
    
    

}
