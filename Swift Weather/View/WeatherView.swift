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
        
    }
    private func sepUpHourlyCollectionView() {
        
    }
    private func setUpInfoCollectionVIew() {
        
    }
    
    func refreshData() {
        setUpCurrentWeather()
    }
    
    
    private func setUpCurrentWeather() {
        cityLabel.text = currentWeather.city
        dateLabel.text = "Today, \(currentWeather.date.shortDate())"
        weatherInfoLabel.text = currentWeather.weatherType
        temperatureLabel.text = "\(currentWeather.currentTemp)"
        
    }
    
}
