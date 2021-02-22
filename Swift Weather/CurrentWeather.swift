//
//  CurrentWeather.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/02/19.
//

import Foundation
import Alamofire
import SwiftyJSON

class CurrentWeather {
    
    var city:String = ""
    var date:String = ""
    var temp:Double = 0.0
    var weatherInfo:String = ""
    
    func getCurrentWeather(completion:@escaping() -> Void) {
        let lon = LocationService.shared.longitude!
        let lat = LocationService.shared.latitude!
        let path =  "https://api.weatherbit.io/v2.0/current?lat=\(lat)&lon=\( lon)&key=\(KeyCenter.key)&include=minutely"
        
        AF.request(path).responseJSON { (response) in
            let result = response.result
            
            switch result {
            
            case .success(let value as [String:Any]):
                let json = JSON(value)
                let data = json["data"][0]
                self.city = data["city_name"].stringValue
                self.date = currentDateFromUnix(unixDate: data["ts"].double)?.shortDate() ?? ""
                self.temp = data["temp"].double ?? 0.0
                self.weatherInfo = data["weather"]["description"].stringValue
                completion()
                
            case .failure(let error):
                print(error.errorDescription ?? "")
            default:
                fatalError()
            }
            
        }
        
    }
}
