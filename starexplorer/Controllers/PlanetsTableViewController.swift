//
//  PlanetsTableViewController.swift
//  starexplorer
//
//  Created by Danny on 18.10.18.
//  Copyright © 2018 AFDanny. All rights reserved.
//

import UIKit


class PlanetsTableViewController: UITableViewController,UISearchBarDelegate, UISearchDisplayDelegate{
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var planetsTableView: UITableView!
    @IBOutlet var btnSearch: UIBarButtonItem!

    
    var activityIndicatorView: UIActivityIndicatorView!
    var planets:[Planet] = [Planet]()
    var nextPlanetsUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        planetsTableView.delegate = self
        planetsTableView.dataSource = self
        
        //Remove search bar from table view header
        planetsTableView.tableHeaderView = UIView()
        
        searchBar.delegate = self
        searchBar.placeholder = "Search planet by name"
        
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        planetsTableView.backgroundView = activityIndicatorView
        
        // Load planets
        loadPlanets();
    }
    
    
    
    @IBAction func searchClicked(_ sender: Any) {
        // Show searchbar in navigation bar
        self.navigationItem.rightBarButtonItem = nil
        navigationItem.titleView = searchBar
        searchBar.showsScopeBar = false
        // Get focus
        searchBar.becomeFirstResponder()
    }
    
    func loadPlanets(){
        planetsTableView.separatorStyle = .none
        activityIndicatorView.startAnimating()
        SWAPIClient.sharedInstance.getPlanets(onSuccess: { json in
            DispatchQueue.main.sync {
                self.planets = [Planet]()
                // Decode and display planets
                let newPlanets = try! JSONDecoder().decode([Planet].self, from: String(describing: json["results"]).data(using: .utf8)!)
                self.planets.append(contentsOf: newPlanets)
                self.nextPlanetsUrl = json["next"].rawString()
                if self.nextPlanetsUrl != "null"{
                    self.loadMorePlanets()
                }else{
                    self.planetsTableView.reloadData()
                    self.planetsTableView.separatorStyle = .singleLine
                    self.activityIndicatorView.stopAnimating()
                }
            }
        }, onFailure: { error in
            DispatchQueue.main.sync {
                self.showErrorMessage(message : "No internet access")
                self.planetsTableView.separatorStyle = .singleLine
                self.activityIndicatorView.stopAnimating()
            }
        })
    }
    

    func loadMorePlanets(){
        SWAPIClient.sharedInstance.getPlanetsByPage(pageUrl: self.nextPlanetsUrl!, onSuccess: { json in
            DispatchQueue.main.sync {
                // Decode and display more planets (next pages)
                let newPlanets = try! JSONDecoder().decode([Planet].self, from: String(describing: json["results"]).data(using: .utf8)!)
                self.planets.append(contentsOf: newPlanets)
                self.nextPlanetsUrl = json["next"].rawString()
                if self.nextPlanetsUrl != "null" {
                    self.loadMorePlanets()
                }else{
                    self.planetsTableView.reloadData()
                    self.planetsTableView.separatorStyle = .singleLine
                    self.activityIndicatorView.stopAnimating()
                }
            }
        }, onFailure: { error in
            DispatchQueue.main.sync {
                self.showErrorMessage(message : "No internet access")
                self.planetsTableView.separatorStyle = .singleLine
                self.activityIndicatorView.stopAnimating()
            }
        })
    }
    
    func showErrorMessage(message : String) {
        let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        errorAlert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { (action: UIAlertAction!) in
            self.loadPlanets()
        }))
        present(errorAlert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
           return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "planetCell", for: indexPath) as! PlanetCell
        let planet = planets[indexPath.row]
        cell.name?.text = planet.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Alternate white and light gray cells
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.white
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        planets = [Planet]()
        planetsTableView.reloadData()
        planetsTableView.separatorStyle = .none
        activityIndicatorView.startAnimating()
        if searchText != "" {
            SWAPIClient.sharedInstance.searchPlanets(searchText: searchText, onSuccess: { json in
                DispatchQueue.main.sync {
                    // Decode and display planets
                    let newPlanets = try! JSONDecoder().decode([Planet].self, from: String(describing: json["results"]).data(using: .utf8)!)
                    self.planets.append(contentsOf: newPlanets)
                    self.nextPlanetsUrl = json["next"].rawString()
                    if self.nextPlanetsUrl != "null"{
                        self.loadMorePlanets()
                    }else{
                        self.planetsTableView.reloadData()
                        self.planetsTableView.separatorStyle = .singleLine
                        self.activityIndicatorView.stopAnimating()
                    }
                }
            }, onFailure: { error in
                DispatchQueue.main.sync {
                    self.showErrorMessage(message : "No internet access")
                    self.planetsTableView.separatorStyle = .singleLine
                    self.activityIndicatorView.stopAnimating()
                }
            })
        }else {
            self.loadPlanets()
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Remove searchbar
        self.navigationItem.rightBarButtonItem = btnSearch
        navigationItem.titleView = nil
        loadPlanets()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass planet to informations view
        if segue.identifier == "planetSegue" {
            if let indexPath = tableView.indexPathForSelectedRow{
                let selectedRow = indexPath.row
                let tabBarController = segue.destination as! UITabBarController
                let planetVC = tabBarController.viewControllers![0] as! PlanetViewController
                planetVC.planet = self.planets[selectedRow]
                print(self.planets[selectedRow].name)
            }
        }
    }
    
    
}


