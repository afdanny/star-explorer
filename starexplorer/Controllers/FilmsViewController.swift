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
        
        // Load planets
        loadFilms();
    }
    
    func loadFilms(){
        filmsTableView.separatorStyle = .none
        activityIndicatorView.startAnimating()
        let planetView = self.tabBarController?.viewControllers?[0] as! PlanetViewController
        for filmUrl in (planetView.planet?.films)!{
            print(filmUrl)
            SWAPIClient.sharedInstance.getFilmByUrl(filmUrl: filmUrl, onSuccess: { json in
                DispatchQueue.main.sync {
                    let film = try! JSONDecoder().decode(Film.self, from: String(describing: json).data(using: .utf8)!)
                    self.films.append(film)
                    self.films.sort() { $0.episode_id < $1.episode_id }
                    print(film.title)
                    self.filmsTableView.reloadData()
                    if(self.films.count == (planetView.planet?.films)!.count){
                        self.filmsTableView.separatorStyle = .singleLine
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
