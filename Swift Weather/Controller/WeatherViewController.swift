//
//  WeatherViewController.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/02/18.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    private func configure() {
        
        //xib띄우려면 반드시 해야함!!!!!!!!!
   
        scrollView.delegate = self
        
        guard let xib = Bundle.main.loadNibNamed("WeatherView", owner: self, options: nil)?.first as? WeatherView else { return}
        xib.setupTableView()
        xib.setupCollectionView()
        xib.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        scrollView.addSubview(xib)

    }
}


extension WeatherViewController:UIScrollViewDelegate {
    
}
