//
//  WeatherLocation.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/02/15.
//

import Foundation

//UserDefaults에 저장하기 위해선 Codable로 만들어줘야함.
struct WeatherLocation:Codable,Equatable {
    var city:String!
    var country:String!
    var countryCode:String!
    var isCurrentLocation:Bool!
    
}
