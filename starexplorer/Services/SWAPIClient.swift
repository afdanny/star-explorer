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
                    onSuccess(jsonData["results"])
                }catch{
                    onFailure(error)
                }
            }
        })
        task.resume()
    }

}
