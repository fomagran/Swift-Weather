//
//  HourlyCollectionViewCell.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/02/18.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func generateCell(hourlyWeahter:HourlyWeather){
        tempLabel.text = "\(hourlyWeahter.temp)"
        timeLabel.text = hourlyWeahter.date
        weatherImage.image = getWeatherIconFor(hourlyWeahter.weatherIcon)
    }

}
