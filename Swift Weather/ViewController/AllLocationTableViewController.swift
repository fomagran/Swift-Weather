//
//  AllLocationTableViewController.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/02/15.
//

import UIKit

class AllLocationTableViewController: UITableViewController {

    
    //MARK:Variables

    var savedLocations:[WeatherLocation]?
    var userDefaults = UserDefaults.standard
    var weatherData = [CityTempData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFromDefaults()
      
    }
    //MARK:UserDefaults
    private func loadFromDefaults() {
        if let data = userDefaults.value(forKey: "Locations") as? Data {
            //데이터로 저장한 객체 decode해줌.
            savedLocations = try? PropertyListDecoder().decode(Array<WeatherLocation>.self,from: data)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return weatherData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllLocationTableViewCell") as! AllLocationTableViewCell
        cell.generateCell(weatherData: weatherData[indexPath.row])
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChooseCityViewController" {
            let vc = segue.destination as! ChooseCityViewController
            vc.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      
        return indexPath.row != 0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let locationToDelete = weatherData[indexPath.row]
            weatherData.remove(at: indexPath.row)
            removeLocationFromSavedLocations(location: locationToDelete.city)
            tableView.reloadData()        }
    }
    
    private func removeLocationFromSavedLocations(location:String) {
        if savedLocations != nil {
            for i in 0...savedLocations!.count - 1 {
                let tempLocation = savedLocations![i]
                if tempLocation.city == location {
                    savedLocations!.remove(at: i)
                    saveNewLocationToUserDefaults()
                    return
                }
            }
        }
    }
    
    private func saveNewLocationToUserDefaults() {
        userDefaults.setValue(try? PropertyListEncoder().encode(savedLocations!), forKey: "Locations")
        userDefaults.synchronize()
    }
}

extension AllLocationTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
    
}

extension AllLocationTableViewController:ChooseCityViewControllerDelegate {
    func didAdd(newLocation: WeatherLocation) {
        print("We have added new location \(newLocation.city)")
    }
}
