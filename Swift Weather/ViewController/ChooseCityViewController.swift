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
        
        //테이블뷰푸터에 이런식으로 서치바를 넣을수 있음.
        tableView.tableFooterView = UIView()
        //테이블뷰헤더에 이런식으로 서치바를 넣을수 있음.
        tableView.tableHeaderView = searchController.searchBar
        loadLocationsFromCSV()
        setUpSearchController()
        
       
    }
    
    private func setUpSearchController() {
        searchController.searchBar.placeholder = "City or Country"
        searchController.searchResultsUpdater  = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        searchController.searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchController.searchBar.sizeToFit()
//        searchController.searchBar.backgroundImage = UIImage()
    }
    
    //MARK:Get Locations
    
    private func loadLocationsFromCSV() {
        if let path = Bundle.main.path(forResource: "location", ofType: "csv") {
            parseCSVAt(url: URL(fileURLWithPath: path))
        }
    }
    
    private func parseCSVAt(url:URL) {
        do {
            
            let data = try Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .utf8)
            
            if let dataArr = dataEncoded?.components(separatedBy: "\n").map({$0.components(separatedBy: ",")}) {
                
                for (i,line) in dataArr.enumerated() {
                    if line.count > 2 && i != 0 {
                        createLocation(line: line)
                    }
                }
            }
            
        } catch  {
            print("Error reading CSV file")
        }
    }
    
    private func createLocation(line:[String]) {
        
        let weatherLocation = WeatherLocation(city: line[0], country: line[1], countryCode: line[2], isCurrentLocation: false)
        allLocations.append(weatherLocation)
    }
    
}


extension ChooseCityViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
    }
    
}

extension ChooseCityViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChoosCityTableViewCell") as! ChoosCityTableViewCell
        
        let location = filteredLocation[indexPath.row]
        cell.textLabel?.text = location.city
        cell.detailTextLabel?.text = location.country
        return cell
    }
}

extension ChooseCityViewController:UISearchResultsUpdating {
    func filteredContentForSearchText(_ searchText:String,scope:String = "All"){
        filteredLocation = allLocations.filter({ (location) -> Bool in
            return location.city.lowercased().contains(searchText.lowercased()) || location.country.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    
}
