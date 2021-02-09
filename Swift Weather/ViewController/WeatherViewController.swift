//
//  ViewController.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/01/19.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let weatherView = WeatherView()
        weatherView.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        scrollView.addSubview(weatherView)
        getCurrentWeather(weatherView: weatherView)
        getWeeklyWeahter(weatherView: weatherView)
        getHourlyWeather(weatherView: weatherView)
    }
    
    
    //MARK:Download Weather
    private func getCurrentWeather(weatherView:WeatherView) {
        
        weatherView.currentWeather = CurrentWeather()
        weatherView.currentWeather.getCurrentWeather { (success) in
        weatherView.refreshData()
            
        }
    }
    private func getWeeklyWeahter(weatherView:WeatherView) {
        
        WeeklyForecast.downloadWeeklyForecastWeather { (weahterForecasts) in
            weatherView.weeklyWeahterForecastData = weahterForecasts
            weatherView.tableView.reloadData()
        }
        
    }
    private func getHourlyWeather(weatherView:WeatherView) {
        
        HourlyForecast.downloadHourlyForecastWeather { (weatherForecasts) in
            weatherView.dailyWeatherForecastData = weatherForecasts
            weatherView.hourlyWeatherCollectionView.reloadData()
        }
        
    }
}

