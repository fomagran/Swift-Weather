//
//  GlobalHelpers.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/01/25.
//

import UIKit

//타임스탬프 Date로 변환하기
func currentDateFromUnix(unixDate:Double?) -> Date? {

    if unixDate != nil {
        return Date(timeIntervalSince1970: unixDate!)
    }else{
        return Date()
    }
}


//글자로 이미지 만들기
func getWeatherIconFor(_ type:String) -> UIImage? {
    return UIImage(named: type)
}

//섭씨 화씨로 바꾸기
func fahrenheitFrom(celsius:Double) -> Double {
    return (celsius * 9/5) + 32
}

func getTempBasedOnSettings(celsious:Double) -> Double  {
    let format = returnTempFormatFromUserDefaults()
    if format == TempFormat.celsius {
        return celsious
    }else{
        return fahrenheitFrom(celsius: celsious)
    }
}

func returnTempFormatFromUserDefaults() -> String{
    if let tempFormat = UserDefaults.standard.value(forKey: "TempFormat") {
        if tempFormat as! Int == 0{
            return TempFormat.celsius
        }else{
            return TempFormat.fahrenheit
        }
       
    }else {
        return TempFormat.celsius
    }
}
