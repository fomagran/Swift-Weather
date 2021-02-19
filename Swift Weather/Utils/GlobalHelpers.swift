//
//  GlobalHelpers.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/02/19.
//

import Foundation

func currentDateFromUnix(unixDate:Double?) -> Date? {

    if unixDate != nil {
        return Date(timeIntervalSince1970: unixDate!)
    }else{
        return Date()
    }
}
