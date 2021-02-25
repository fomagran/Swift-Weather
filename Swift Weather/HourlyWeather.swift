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
    
    class func getHourlyWeather(location:WeatherLocation,completion:@escaping([HourlyWeather]) -> Void) {
        
        let lon = LocationService.shared.longitude!
        let lat = LocationService.shared.latitude!
        var path = ""
        if location.city == "" {
            path =  "https://api.weatherbit.io/v2.0/current?lat=\(lat)&lon=\( lon)&key=\(KeyCenter.key)&include=minutely"
        }else {
            path = String(format: "https://api.weatherbit.io/v2.0/current?city=%@,%@&key=7db3d9a63ac04f71b3de7601957edba4", location.city,location.countryCode)
        }
        
        AF.request(path).responseJSON { (response) in
            let result = response.result
            var hourlyWeathers = [HourlyWeather]()
            
            switch result {
            
            case .success(let value as [String:Any]):
                    if let data = value["data"] as? [Dictionary<String,AnyObject>] {
                        data.forEach{hourlyWeathers.append(HourlyWeather(weatherDictionary: $0))}
                    }
                print(hourlyWeathers.count)
                completion(hourlyWeathers)
                
            case .failure(let error):
                print(error.errorDescription ?? "")
            default:
                fatalError()
            }
        }
        
    }
}
