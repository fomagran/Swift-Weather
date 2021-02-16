//
//  AllLocationTableViewCell.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/02/16.
//

import UIKit

class AllLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func generateCell(weatherData:CityTempData) {
        cityLabel.text = weatherData.city
        cityLabel.adjustsFontSizeToFitWidth = true
        temperatureLabel.text = String(format: "%.0f C",weatherData.temp)
    }

}
