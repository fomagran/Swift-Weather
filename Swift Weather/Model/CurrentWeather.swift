//
//  CurrentWeather.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/01/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class CurrentWeather {

    
    //class func로 만들어주면 다른 뷰컨트롤러에서 사용가능
    class func getCurrentWeather() {
        let LOCATIONAPI_URL = "https://api.weatherbit.io/v2.0/current?city=Seoul,KR&key=7db3d9a63ac04f71b3de7601957edba4"
        
        //Swift5부터 AF로 바뀜.
        AF.request(LOCATIONAPI_URL).responseJSON { (response) in
            let result = response.result
            switch result {
            case .success(let value as [String: Any]):
               let json = JSON(value)
                print(json)
            case .failure(let error):
                print(error)
            default:
                fatalError("received non-dictionary JSON response")
            }
        }
    }
}
