//
//  WeeklyForecast.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/01/25.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeeklyForecast {
    private var _date: Date!
    private var _temperature:Double!
    private var _weatherIcon:String!
    
    var date:Date {
        if _date == nil {
            _date = Date()
        }
        return _date
    }
    
    var temperature:Double {
        if _temperature == nil {
            _temperature = 0.0
        }
        return _temperature
    }
    
    var weatherIcon:String {
        if _weatherIcon == nil {
            _weatherIcon = ""
        }
        return _weatherIcon
    }
    
    init(weatherDictionary:Dictionary<String,Any>) {
        let json = JSON(weatherDictionary)
        self._temperature =  getTempBasedOnSettings(celsious: json["temp"].double ?? 0.0)
        self._date = currentDateFromUnix(unixDate: json["ts"].double!)
        self._weatherIcon = json["weather"]["icon"].string
    }
    
    class func downloadWeeklyForecastWeather(location:WeatherLocation,completion:@escaping(_ weatherForecast:[WeeklyForecast])->Void) {
        
        var url:String!
        
        if !location.isCurrentLocation {
            url = String(format: "https://api.weatherbit.io/v2.0/forecast/daily?city=%@,%@&days=7&key=7db3d9a63ac04f71b3de7601957edba4", location.city,location.countryCode)
        }else{
            url = WEEKLYFORECAST_URL
        }
        
        AF.request(url).responseJSON { (response) in
            let result = response.result
            var weeklyForecastArray:[WeeklyForecast] = []
            switch result {
            case .success(let value as [String: Any]):
                if let dictionary = value as? Dictionary<String,AnyObject> {
                    if var list = dictionary["data"] as? [Dictionary<String,AnyObject>] {
                        //현재 요일은 삭제해준다.
                        list.removeFirst()
                        for item in list{
                            let forecast = WeeklyForecast(weatherDictionary: item)
                            weeklyForecastArray.append(forecast)
                        }
                    }
                }
                completion(weeklyForecastArray)
            case .failure(let error) :
               print("Hourly download Error:",error)
                completion(weeklyForecastArray)
            default :
                completion(weeklyForecastArray)
                print("default")
            }
        }
        
    }
}
