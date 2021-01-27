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
        scrollView.addSubview(weatherView)
        weatherView.frame = CGRect(x: 0, y: 0, width:scrollView.bounds.width, height: scrollView.bounds.height)
        weatherView.currentWeather = CurrentWeather()
        weatherView.currentWeather.getCurrentWeather { (success) in
            weatherView.refreshData()
        }
    }
}

