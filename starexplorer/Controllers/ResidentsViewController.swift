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
        
        // Load planets
        loadResidents();
    }
    
    func loadResidents(){
        residentsTableView.separatorStyle = .none
        activityIndicatorView.startAnimating()
        let planetView = self.tabBarController?.viewControllers?[0] as! PlanetViewController
        for residentUrl in (planetView.planet?.residents)!{
            print(residentUrl)
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
                print(error.localizedDescription)
            })
        }
    }
    
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return residents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "residentCell", for: indexPath) as! ResidentCell
        let resident = residents[indexPath.row]
        cell.lblName?.text = resident.name
        print(resident.name)
        print(resident.gender)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
