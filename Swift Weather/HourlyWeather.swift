//
//  HourlyWeather.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/02/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class HourlyWeather {
    
    var date:String = ""
    var temp:Double = 0.0
    var weatherIcon:String = ""
    
    init(weatherDictionary:Dictionary<String,Any>) {
        let data = JSON(weatherDictionary)
        self.date = currentDateFromUnix(unixDate: data["ts"].double)?.time() ?? ""
        self.temp = data["temp"].double ?? 0.0
        self.weatherIcon = data["weather"]["icon"].stringValue
    }
    
    class func getHourlyWeather(completion:@escaping([HourlyWeather]) -> Void) {
        
        let lon = LocationService.shared.longitude!
        let lat = LocationService.shared.latitude!
        
        let path = "https://api.weatherbit.io/v2.0/forecast/hourly?lat=\(lat)&lon=\(lon)&key=\(KeyCenter.key)"
        
        AF.request(path).responseJSON { (response) in
            let result = response.result
            var hourlyWeathers = [HourlyWeather]()
            
            switch result {
            
            case .success(let value as [String:Any]):
                    if let data = value["data"] as? [Dictionary<String,AnyObject>] {
                        data.forEach{hourlyWeathers.append(HourlyWeather(weatherDictionary: $0))}
                    }
                completion(hourlyWeathers)
                
            case .failure(let error):
                print(error.errorDescription ?? "")
            default:
                fatalError()
            }
        }
        
    }
}
