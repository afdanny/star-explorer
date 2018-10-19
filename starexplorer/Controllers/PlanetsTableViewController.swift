//
//  PlanetsTableViewController.swift
//  starexplorer
//
//  Created by Danny on 18.10.18.
//  Copyright © 2018 AFDanny. All rights reserved.
//

import UIKit

class PlanetsTableViewController: UITableViewController {
    
    @IBOutlet var planetsTableView: UITableView!
    var planets:[Planet] = [Planet]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        planetsTableView.delegate = self
        planetsTableView.dataSource = self
        
        // Load planets
        SWAPIClient.sharedInstance.getPlanets(onSuccess: { json in
            DispatchQueue.main.async {
                // Decode and display planets
                self.planets = try! JSONDecoder().decode([Planet].self, from: String(describing: json).data(using: .utf8)!)
                self.planetsTableView.reloadData()
            }
        }, onFailure: { error in
            let alert = UIAlertController(title: "Error", message: "Failed to loading planets", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.show(alert, sender: nil)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
