//
//  Constants.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/02/25.
//

import Foundation

//현재 도시 현재 날씨
let CURRENT_LOCATIONAPI_URL = "https://api.weatherbit.io/v2.0/current?lat=\(LocationService.shared.latitude!)&lon=\(LocationService.shared.longitude!)&key=7db3d9a63ac04f71b3de7601957edba4"

//현재 도시 24시간
let HOURLY_FORECAST_URL = "https://api.weatherbit.io/v2.0/forecast/hourly?lat=\(LocationService.shared.latitude!)&lon=\(LocationService.shared.longitude!)&hour=24&key=7db3d9a63ac04f71b3de7601957edba4"

//현재 도시 일주일
let WEEKLY_FORECAST_URL = "https://api.weatherbit.io/v2.0/forecast/daily?lat=\(LocationService.shared.latitude!)&lon=\(LocationService.shared.longitude!)&days=7&key=7db3d9a63ac04f71b3de7601957edba4"
