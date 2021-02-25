//
//  WeeklyWeather.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/02/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeeklyWeather {
    var date:String = ""
    var temp:Double = 0.0
    var weatherIcon:String = ""
    
    
    init(weatherDictionary:Dictionary<String,Any>) {
        let data = JSON(weatherDictionary)
        self.date = String("\(currentDateFromUnix(unixDate: data["ts"].double) ?? Date())".prefix(10))
        self.temp = data["temp"].double ?? 0.0
        self.weatherIcon = data["weather"]["icon"].stringValue
    }
    
    
    class func getWeeklyWeather(location:WeatherLocation,completion:@escaping ([WeeklyWeather]) -> Void) {
        
        var path = String()
        if location.city == "" {
            path =  WEEKLY_FORECAST_URL
        }else {
            path = String(format: "https://api.weatherbit.io/v2.0/forecast/daily?city=%@,%@&days=7&key=7db3d9a63ac04f71b3de7601957edba4", location.city,location.countryCode)
        }
        
        AF.request(path).responseJSON { (response) in
            let result = response.result
            var weeklyWeathers = [WeeklyWeather]()
            
            switch result {
            case .success(let value as [String:Any]) :
                if let data = value["data"] as? [Dictionary<String,AnyObject>]  {
                    data.forEach {weeklyWeathers.append(WeeklyWeather(weatherDictionary: $0))}
                }
                completion(weeklyWeathers)
            case .failure(let error):
                print(error.errorDescription ?? "")
                
            default :
                fatalError()
            }
        }

    }
}
