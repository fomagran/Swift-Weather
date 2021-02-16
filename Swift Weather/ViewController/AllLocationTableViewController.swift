//
//  AllLocationTableViewController.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/02/15.
//

import UIKit

class AllLocationTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChooseCityViewController" {
            let vc = segue.destination as! ChooseCityViewController
            vc.delegate = self
        }
    }



}

extension AllLocationTableViewController:ChooseCityViewControllerDelegate {
    func didAdd(newLocation: WeatherLocation) {
        print("We have added new location \(newLocation.city)")
    }
}
