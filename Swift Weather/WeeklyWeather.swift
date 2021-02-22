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
    
    
    class func getWeeklyWeather(completion:@escaping ([WeeklyWeather]) -> Void) {
        
        let lat = LocationService.shared.latitude!
        let lon = LocationService.shared.longitude!
        let path = "https://api.weatherbit.io/v2.0/forecast/daily=7?lat=\(lat)&lon=\(lon)&key=\(KeyCenter.key)"
        
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
