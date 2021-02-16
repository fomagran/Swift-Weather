//
//  ChooseCityViewController.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/02/15.
//

import UIKit

protocol ChooseCityViewControllerDelegate {
    func didAdd(newLocation:WeatherLocation)
}

class ChooseCityViewController: UIViewController {
    
    //MARK:IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:Variables
    
    var allLocations:[WeatherLocation] = []
    var filteredLocation:[WeatherLocation] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let userDefaults = UserDefaults.standard
    var savedLocations: [WeatherLocation]?
    var delegate:ChooseCityViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //테이블뷰푸터에 이런식으로 서치바를 넣을수 있음.
        tableView.tableFooterView = UIView()
        //테이블뷰헤더에 이런식으로 서치바를 넣을수 있음.
        tableView.tableHeaderView = searchController.searchBar
        loadLocationsFromCSV()
        setUpSearchController()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpTapGesture()
        loadFromDefaults()
    }
    
    private func setUpSearchController() {
        searchController.searchBar.placeholder = "City or Country"
        searchController.searchResultsUpdater  = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        searchController.searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchController.searchBar.sizeToFit()
    }
    
    private func setUpTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped))
        self.tableView.backgroundView = UIView()
        self.tableView.backgroundView?.addGestureRecognizer(tap)
    }
    
    @objc private func tableTapped() {
        dismissView()
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
    
    //MARK: UserDefaults
    
    private func saveToUserrDefaults(location:WeatherLocation) {
        if savedLocations != nil {
            if !savedLocations!.contains(location) {
                savedLocations!.append(location)
            }
        }else{
            savedLocations = [location]
        }
        //UserDefaults에 저장하기 위해선 encode해서 데이터로 넣어야함.
        userDefaults.setValue(try? PropertyListEncoder().encode(savedLocations!), forKey: "Locations")
        userDefaults.synchronize()
    }
    
    private func loadFromDefaults() {
        if let data = userDefaults.value(forKey: "Locations") as? Data {
            //데이터로 저장한 객체 decode해줌.
            savedLocations = try? PropertyListDecoder().decode(Array<WeatherLocation>.self,from: data)
        }
    }
    
    private func dismissView() {
        if searchController.isActive {
            searchController.dismiss(animated: true) {
                self.dismiss(animated: true, completion: nil)
            }
        }else {
            dismiss(animated: true, completion: nil)
        }
    }
}


extension ChooseCityViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        saveToUserrDefaults(location: filteredLocation[indexPath.row])
        delegate?.didAdd(newLocation: filteredLocation[indexPath.row])
        dismissView()
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
