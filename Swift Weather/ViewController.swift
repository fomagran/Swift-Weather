//
//  ViewController.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/01/19.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let currentWeather = CurrentWeather()
        //콜백함수 받기
        currentWeather.getCurrentWeather { (success) in
            if success {
                print(currentWeather.city)
            }
        }
        
    }


}

