//
//  WeatherView.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/02/18.
//

import UIKit

class WeatherView: UIView {

    //MARK:IBOutlets
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherInfoLabel: UILabel!
    @IBOutlet weak var weeklyTableView: UITableView!
    @IBOutlet weak var hourlyInfoCollectionView: UICollectionView!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    
    var currentWeather:CurrentWeather!
    var hourlyWeathers:[HourlyWeather] = []
    var weeklyWeathers:[WeeklyWeather] = []
    
    //MARK:LifeCycle
    
    func setupAll() {
        setupCurrentWeather()
        setupCollectionView()
        setupTableView()
    }
    
    func setupCurrentWeather() {
        self.cityLabel.text = currentWeather.city
        self.dateLabel.text = "Today, \(currentWeather.date)"
        self.tempLabel.text = "\(currentWeather.temp)"
        self.weatherInfoLabel.text = currentWeather.weatherInfo
    }
    
    
    func setupTableView() {
        weeklyTableView.register(UINib(nibName: "WeeklyTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "Cell")
        weeklyTableView.dataSource = self
    }
    
    func setupCollectionView(){
        hourlyCollectionView.register(UINib(nibName: "HourlyCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "Cell")
        hourlyCollectionView.dataSource = self
    }
    
}

//MARK:TableView DataSource

extension WeatherView:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weeklyWeathers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! WeeklyTableViewCell
        cell.generateCell(weather: weeklyWeathers[indexPath.row])
        return cell
    }
    
    
}

//MARK:CollectionView DataSource

extension WeatherView:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyWeathers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as!
            HourlyCollectionViewCell
        cell.generateCell(hourlyWeahter: hourlyWeathers[indexPath.item])
        return cell
    }
}
