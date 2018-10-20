//
//  PlanetsTableViewController.swift
//  starexplorer
//
//  Created by Danny on 18.10.18.
//  Copyright © 2018 AFDanny. All rights reserved.
//

import UIKit


class PlanetsTableViewController: UITableViewController,UISearchBarDelegate, UISearchDisplayDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var planetsTableView: UITableView!
    
    
    var activityIndicatorView: UIActivityIndicatorView!
    var planets:[Planet] = [Planet]()
    var nextPlanetsUrl: String?
    var loadingPlanets = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        planetsTableView.delegate = self
        planetsTableView.dataSource = self
        
        searchBar.delegate = self
        planetsTableView.tableHeaderView = UIView()
        navigationItem.titleView = searchBar
        searchBar.showsScopeBar = false
        searchBar.placeholder = "Search planet by name"
        
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        planetsTableView.backgroundView = activityIndicatorView
        
        // Load planets
        loadPlanets();
    }
    
    
    func loadPlanets(){
        planetsTableView.separatorStyle = .none
        activityIndicatorView.startAnimating()
        self.loadingPlanets = true
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
                    self.loadingPlanets = false;
                    self.planetsTableView.separatorStyle = .singleLine
                    self.activityIndicatorView.stopAnimating()
                }
            }
        }, onFailure: { error in
            print(error.localizedDescription)
//            let alert = UIAlertController(title: "Error", message: "Failed to loading planets", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
//            self.show(alert, sender: nil)
            DispatchQueue.main.sync {
            self.loadingPlanets = false;
            self.planetsTableView.separatorStyle = .singleLine
            self.activityIndicatorView.stopAnimating()
            }
        })
    }
    
    func loadMorePlanets(){
        SWAPIClient.sharedInstance.getPlanetsByPage(pageUrl: self.nextPlanetsUrl!, onSuccess: { json in
            DispatchQueue.main.sync {
                // Decode and display planets
                let newPlanets = try! JSONDecoder().decode([Planet].self, from: String(describing: json["results"]).data(using: .utf8)!)
                self.planets.append(contentsOf: newPlanets)
                self.nextPlanetsUrl = json["next"].rawString()
                if self.nextPlanetsUrl != "null" {
                    self.loadMorePlanets()
                }else{
                    self.planetsTableView.reloadData()
                    self.loadingPlanets = false;
                    self.planetsTableView.separatorStyle = .singleLine
                    self.activityIndicatorView.stopAnimating()
                }
            }
        }, onFailure: { error in
            print(error.localizedDescription)
//            let alert = UIAlertController(title: "Error", message: "Failed to loading planets", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
//            self.show(alert, sender: nil)
            DispatchQueue.main.sync {
                self.loadingPlanets = false;
                self.planetsTableView.separatorStyle = .singleLine
                self.activityIndicatorView.stopAnimating()
            }
        })
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
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.white
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            self.loadingPlanets = true
            SWAPIClient.sharedInstance.searchPlanets(searchText: searchText, onSuccess: { json in
                DispatchQueue.main.sync {
                    // Decode and display planets
                    self.planets = [Planet]()
                    let newPlanets = try! JSONDecoder().decode([Planet].self, from: String(describing: json["results"]).data(using: .utf8)!)
                    self.planets.append(contentsOf: newPlanets)
                    self.planetsTableView.reloadData()
                    self.nextPlanetsUrl = json["next"].rawString()
                    self.loadingPlanets = false;
                    self.planetsTableView.separatorStyle = .singleLine
                    self.activityIndicatorView.stopAnimating()
                }
            }, onFailure: { error in
                print(error.localizedDescription)
                //            let alert = UIAlertController(title: "Error", message: "Failed to loading planets", preferredStyle: .alert)
                //            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                //            self.show(alert, sender: nil)
                DispatchQueue.main.sync {
                    self.loadingPlanets = false;
                    self.planetsTableView.separatorStyle = .singleLine
                    self.activityIndicatorView.stopAnimating()
                }
            })
        }else {
            self.loadPlanets()
        }
        
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "planetSegue" {
            if let indexPath = tableView.indexPathForSelectedRow{
                let selectedRow = indexPath.row
                let tabBarController = segue.destination as! UITabBarController
                let planetVC = tabBarController.viewControllers![0] as! PlanetViewController
                planetVC.planet = self.planets[selectedRow]
                print(self.planets[selectedRow].name)
            }        }
    }
    
    
}
