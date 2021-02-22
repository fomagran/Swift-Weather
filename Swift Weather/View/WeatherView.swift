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
    
    //MARK:LifeCycle
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
      
    }
    
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
        
        hourlyInfoCollectionView.register(UINib(nibName: "HourlyInfoCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "Cell")
        hourlyInfoCollectionView.dataSource = self
    }
    
}

//MARK:TableView Deleagate & DataSource

extension WeatherView:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! WeeklyTableViewCell
        return cell
    }
    
    
}

//MARK:CollectionView Deleagate & DataSource

extension WeatherView:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionView == hourlyCollectionView ? hourlyWeathers.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == hourlyCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as!
                HourlyCollectionViewCell
            cell.generateCell(hourlyWeahter: hourlyWeathers[indexPath.item])
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HourlyInfoCollectionViewCell
            return cell
        }
    }
}
