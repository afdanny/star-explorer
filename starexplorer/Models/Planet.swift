//
//  Planet.swift
//  starexplorer
//
//  Created by Danny on 18.10.18.
//  Copyright © 2018 AFDanny. All rights reserved.
//

import UIKit

class Planet: Codable {
    
    let name : String
    let rotation_period:String
    let orbital_period:String
    let diameter:String
    let climate:String
    let gravity:String
    let terrain:String
    let surface_water:String
    let population:String
    let residents:[String]
    let films:[String]
}
