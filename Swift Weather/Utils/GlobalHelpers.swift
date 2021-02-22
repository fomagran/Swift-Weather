//
//  GlobalHelpers.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/02/19.
//

import UIKit

//Double로 오는 타임스탬프 데이트 형식으로 변환
func currentDateFromUnix(unixDate:Double?) -> Date? {
    if unixDate != nil {
        return Date(timeIntervalSince1970: unixDate!)
    }else{
        return Date()
    }
}

//날씨 아이콘 이름에 따라서 이미지로 변환
func getWeatherIconFor(_ type:String) -> UIImage? {
    return UIImage(named: type)
}
