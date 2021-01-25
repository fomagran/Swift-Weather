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
        self._temperature = json["temp"].double
        self._date = currentDateFromUnix(unixDate: json["ts"].double!)
        self._weatherIcon = json["weather"]["icon"].string
    }
    
    class func downloadWeeklyForecastWeather(completion:@escaping(_ weatherForecast:[WeeklyForecast])->Void) {
        
        
        AF.request(WEEKLYFORECAST_URL).responseJSON { (response) in
            let result = response.result
            var weeklyForecastArray:[WeeklyForecast] = []
            switch result {
            case .success(let value as [String: Any]):
               print("Success")
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
