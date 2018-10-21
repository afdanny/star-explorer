//
//  MoviesViewController.swift
//  starexplorer
//
//  Created by Danny on 20.10.18.
//  Copyright © 2018 AFDanny. All rights reserved.
//

import UIKit

class FilmsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var filmsTableView: UITableView!
    
    var activityIndicatorView: UIActivityIndicatorView!
    var films:[Film] = [Film]()
    var nextFilmsUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filmsTableView.delegate = self
        filmsTableView.dataSource = self
        
        
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        filmsTableView.backgroundView = activityIndicatorView
        
        // Load films
        let planetView = self.tabBarController?.viewControllers?[0] as! PlanetViewController
        if (planetView.planet?.films.count)! > 0 {
            loadFilms();
        }
    }
    
    func loadFilms(){
        filmsTableView.separatorStyle = .none
        activityIndicatorView.startAnimating()
        let planetView = self.tabBarController?.viewControllers?[0] as! PlanetViewController
        for filmUrl in (planetView.planet?.films)!{
            SWAPIClient.sharedInstance.getFilmByUrl(filmUrl: filmUrl, onSuccess: { json in
                DispatchQueue.main.sync {
                    let film = try! JSONDecoder().decode(Film.self, from: String(describing: json).data(using: .utf8)!)
                    self.films.append(film)
                    if(self.films.count == (planetView.planet?.films)!.count){
                        self.films.sort() { $0.episode_id < $1.episode_id }
                        self.filmsTableView.reloadData()
                        self.filmsTableView.separatorStyle = .singleLine
                        self.activityIndicatorView.stopAnimating()
                    }
                }
            }, onFailure: { error in
                DispatchQueue.main.sync {
                    self.showErrorMessage(message : "No internet access")
                    self.filmsTableView.separatorStyle = .singleLine
                    self.activityIndicatorView.stopAnimating()
                }
            })
        }
    }
    
    func showErrorMessage(message : String) {
        let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        errorAlert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { (action: UIAlertAction!) in
            self.loadFilms()
        }))
        present(errorAlert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filmCell", for: indexPath) as! FilmCell
        let film = films[indexPath.row]
        cell.lblEpisode?.text = String(film.episode_id)
        cell.lblTitle?.text = film.title
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
