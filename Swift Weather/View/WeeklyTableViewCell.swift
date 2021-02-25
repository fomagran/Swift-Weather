//
//  WeeklyTableViewCell.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/02/18.
//

import UIKit

class WeeklyTableViewCell: UITableViewCell {

    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func generateCell(weather:WeeklyWeather) {
        weekLabel.text = weather.date
        weatherImage.image = getWeatherIconFor(weather.weatherIcon)
        tempLabel.text = "\(weather.temp)"
    }
}
