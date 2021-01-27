//
//  ForecastCollectionViewCell.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/01/27.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func generateCell(weather:HourlyForecast) {
        timeLabel.text =  weather.date.time()
        tempLabel.text = "\(weather.temperature)"
        weatherIconImageView.image = getWeatherIconFor(weather.weatherIcon)
    }

}
