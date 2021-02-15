//
//  ChooseCityViewController.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/02/15.
//

import UIKit

class ChooseCityViewController: UIViewController {
    
    //MARK:IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:Variables
    
    var allLocations:[WeatherLocation] = []
    var filteredLocation:[WeatherLocation] = []
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        loadLacationsFromCSV()
       
    }
    
    //MARK:Get Locations
    
    private func loadLacationsFromCSV() {
        if let path = Bundle.main.path(forResource: "location", ofType: "csv") {
            parseCSVAt(url: URL(fileURLWithPath: path))
        }
    }
    
    private func parseCSVAt(url:URL) {
        do {
            
            let data = try Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .utf8)
            
            if let dataArr = dataEncoded?.components(separatedBy: "\n").map{$0.components(separatedBy: ",")} {
    
                
                for (i,line) in dataArr.enumerated() {
                    if line.count > 2 && i != 0 {
                        
                    }
                    print(line,"\n")
                }
            }
            
        } catch  {
            print("Error reading CSV file")
        }
    }
}

extension ChooseCityViewController:UITableViewDelegate {
    
}

extension ChooseCityViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "") as! WeatherTableViewCell
        return cell
    }
    
    
}
