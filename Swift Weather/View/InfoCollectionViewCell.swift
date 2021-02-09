//
//  InfoCollectionViewCell.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/02/09.
//

import UIKit

class InfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func generateCell(weatherInfo:WeatherInfo) {
        infoLabel.text = weatherInfo.infoText
        //width에 맞춰서 폰트사이즈 조정하기
        infoLabel.adjustsFontSizeToFitWidth = true
        
        if weatherInfo.image != nil {
            nameLabel.isHidden = true
            imageView.isHidden  =  false
            imageView.image = weatherInfo.image
        }else {
            nameLabel.isHidden = false
            imageView.isHidden  =  true
            nameLabel.adjustsFontSizeToFitWidth
             = true
            nameLabel.text = weatherInfo.nameText
        }
    }
    
}
