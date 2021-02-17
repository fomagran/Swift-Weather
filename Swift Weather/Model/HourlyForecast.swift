//
//  HourlyForecast.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/01/25.
//

import Foundation
import Alamofire
import SwiftyJSON

class HourlyForecast {
    
    //shift control 누르고 여러줄 클릭하면 한번에 이름 바꿀 수 있다.
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
        self._temperature = json["temp"].double
        self._date = currentDateFromUnix(unixDate: json["ts"].double!)
        self._weatherIcon = json["weather"]["icon"].string
    }
    
    class func downloadHourlyForecastWeather(location:WeatherLocation,completion:@escaping (_ hourlyForecast:[HourlyForecast])->Void) {
        
        var url:String!
        
        if !location.isCurrentLocation {
            url = String(format: "https://api.weatherbit.io/v2.0/forecast/hourly?city=%@,%@&hour=24&key=7db3d9a63ac04f71b3de7601957edba4", location.city,location.countryCode)
        }else{
            url = HOURLYFORECAST_URL
        }
        
        AF.request(url).responseJSON { (response) in
            let result = response.result
            var forecastArray:[HourlyForecast] = []
            switch result {
            case .success(let value as [String: Any]):
                if let dictionary = value as? Dictionary<String,AnyObject> {
                    if let list = dictionary["data"] as? [Dictionary<String,AnyObject>] {
                        for item in list{
                            let forecast = HourlyForecast(weatherDictionary: item)
                            forecastArray.append(forecast)
                            
                        }
                    }
                }
                completion(forecastArray)
            case .failure(let error) :
               print("Hourly download Error:",error)
                completion(forecastArray)
            default :
                completion(forecastArray)
                print("default")
            }
        }
        
    }
    
}
