//
//  ViewController.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/01/19.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        HourlyForecast.downloadHourlyForecastWeather { (hourlyForecastArray) in
            for  data in hourlyForecastArray {
                print("forecastData:",data.temperature)
            }
        }
        
        WeeklyForecast.downloadWeeklyForecastWeather { (weeklyForecastArray) in
            for  data in weeklyForecastArray {
                print("forecastData:",data.temperature)
            }
        }
        
        
        
    }


}

