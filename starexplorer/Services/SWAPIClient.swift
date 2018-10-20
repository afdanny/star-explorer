//
//  SWAPIClient.swift
//  starexplorer
//
//  Created by Danny on 18.10.18.
//  Copyright © 2018 AFDanny. All rights reserved.
//

import UIKit
import SwiftyJSON

class SWAPIClient {
        
    let baseURL = "https://swapi.co/api"
    static let sharedInstance = SWAPIClient()
    static let getPlanetsEndpoint = "/planets/"
    static let getFilmsEndpoint = "/films/"
    static let searchEndpoint = "?search="
    
    func getPlanets(onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = baseURL + SWAPIClient.getPlanetsEndpoint
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                do{
                    let jsonData = try JSON(data: data!)
                    onSuccess(jsonData)
                }catch{
                    onFailure(error)
                }
            }
        })
        task.resume()
    }
        
    func getPlanetsByPage(pageUrl: String, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: pageUrl)! as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                do{
                    let jsonData = try JSON(data: data!)
                    onSuccess(jsonData)
                }catch{
                    onFailure(error)
                }
            }
        })
        task.resume()
    }
    
    func searchPlanets(searchText:String, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = baseURL + SWAPIClient.getPlanetsEndpoint + SWAPIClient.searchEndpoint + searchText
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                do{
                    let jsonData = try JSON(data: data!)
                    onSuccess(jsonData)
                }catch{
                    onFailure(error)
                }
            }
        })
        task.resume()
    }
    
    func getFilmByUrl(filmUrl: String, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = filmUrl
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                do{
                    let jsonData = try JSON(data: data!)
                    onSuccess(jsonData)
                }catch{
                    onFailure(error)
                }
            }
        })
        task.resume()
    }
    
    func getResidentByUrl(residentUrl: String, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = residentUrl
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                do{
                    let jsonData = try JSON(data: data!)
                    onSuccess(jsonData)
                }catch{
                    onFailure(error)
                }
            }
        })
        task.resume()
    }

}
