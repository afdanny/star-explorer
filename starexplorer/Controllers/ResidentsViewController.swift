//
//  ResidentsViewController.swift
//  starexplorer
//
//  Created by Danny on 20.10.18.
//  Copyright © 2018 AFDanny. All rights reserved.
//

import UIKit

class ResidentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var residentsTableView: UITableView!
    
    var activityIndicatorView: UIActivityIndicatorView!
    var residents:[Resident] = [Resident]()
    var nextresidentsUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        residentsTableView.delegate = self
        residentsTableView.dataSource = self
        
        
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        residentsTableView.backgroundView = activityIndicatorView
        
        // Load residents
        let planetView = self.tabBarController?.viewControllers?[0] as! PlanetViewController
        if (planetView.planet?.residents.count)! > 0 {
            loadResidents();
        }
    }
    
    func loadResidents(){
        residentsTableView.separatorStyle = .none
        activityIndicatorView.startAnimating()
        let planetView = self.tabBarController?.viewControllers?[0] as! PlanetViewController
        for residentUrl in (planetView.planet?.residents)!{
            SWAPIClient.sharedInstance.getResidentByUrl(residentUrl: residentUrl, onSuccess: { json in
                DispatchQueue.main.sync {
                    let resident = try! JSONDecoder().decode(Resident.self, from: String(describing: json).data(using: .utf8)!)
                    self.residents.append(resident)
                    if(self.residents.count == (planetView.planet?.residents)!.count){
                        self.residents.sort() { $0.name < $1.name }
                        self.residentsTableView.reloadData()
                        self.residentsTableView.separatorStyle = .singleLine
                        self.activityIndicatorView.stopAnimating()
                    }
                }
            }, onFailure: { error in
                DispatchQueue.main.sync {
                    self.showErrorMessage(message : "No internet access")
                    self.residentsTableView.separatorStyle = .singleLine
                    self.activityIndicatorView.stopAnimating()
                }
            })
        }
    }
    
    func showErrorMessage(message : String) {
        let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        errorAlert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { (action: UIAlertAction!) in
            self.loadResidents()
        }))
        present(errorAlert, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return residents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "residentCell", for: indexPath) as! ResidentCell
        let resident = residents[indexPath.row]
        cell.lblName?.text = resident.name
        if resident.gender == "male" {
            cell.imageGender.image = UIImage(named:"MaleIcon")
        }else if resident.gender == "female"{
            cell.imageGender.image = UIImage(named:"FemaleIcon")
        }else{
            cell.imageGender.isHidden = true
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.white
        }
    }
}
