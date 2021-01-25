//
//  Constants.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/01/25.
//

import Foundation

//도시에 따라서 데이터 받아오기
let LOCATIONAPI_URL = "https://api.weatherbit.io/v2.0/current?city=Seoul,KR&key=7db3d9a63ac04f71b3de7601957edba4"

//도시정하고 24시간 기준으로 날씨정보 받아오기
let HOURLYFORECAST_URL = "https://api.weatherbit.io/v2.0/forecast/hourly?city=Seoul,KR&hour=24&key=7db3d9a63ac04f71b3de7601957edba4"

//일주일 기준으로 날씨정보 받아오기
let WEEKLYFORECAST_URL = "https://api.weatherbit.io/v2.0/forecast/daily?city=Seoul,KR&days=7&key=7db3d9a63ac04f71b3de7601957edba4"
