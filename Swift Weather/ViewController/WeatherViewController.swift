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

        
        WeeklyForecast.downloadWeeklyForecastWeather { (weeklyForecastArray) in
            for  data in weeklyForecastArray {
                print("forecastData:",data.date)
            }
        }
        
        
        
    }


}

