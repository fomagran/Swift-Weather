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
