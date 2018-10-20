//
//  PlanetViewController.swift
//  starexplorer
//
//  Created by Danny on 18.10.18.
//  Copyright © 2018 AFDanny. All rights reserved.
//

import UIKit

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "'"
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension BinaryInteger {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}

class PlanetViewController: UIViewController {
    
    var planet: Planet?

    @IBOutlet weak var lblRotationPeriod: UILabel!
    @IBOutlet weak var lblOrbitalPeriod: UILabel!
    @IBOutlet weak var lblDiameter: UILabel!
    @IBOutlet weak var lblGravity: UILabel!
    @IBOutlet weak var lblPopulation: UILabel!
    @IBOutlet weak var lblSurfaceWater: UILabel!
    @IBOutlet weak var lblTerrain: UILabel!
    @IBOutlet weak var lblClimate: UILabel!
    @IBOutlet weak var lblPlanetName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        // Do any additional setup after loading the view.
    }

    
    func loadData(){
        if let p = planet{
//            lblPlanetName.text = p.name
//            lblClimate.text = p.climate
//            lblRotationPeriod.text = (Int(p.rotation_period)?.formattedWithSeparator)! + " hours"
//            lblOrbitalPeriod.text = (Int(p.orbital_period)?.formattedWithSeparator)! + " days"
//            lblDiameter.text = (Int(p.diameter)?.formattedWithSeparator)! + " km"
//            lblGravity.text = p.gravity + " Gs"
//            lblPopulation.text = Int(p.population)?.formattedWithSeparator
//            lblSurfaceWater.text = p.surface_water + "%"
//            lblTerrain.text = p.terrain
            
            lblPlanetName.text = p.name
            lblClimate.text = p.climate
            lblRotationPeriod.text = p.rotation_period + " hours"
            lblOrbitalPeriod.text = p.orbital_period + " days"
            lblDiameter.text = p.diameter + " km"
            lblGravity.text = p.gravity + " Gs"
            lblPopulation.text = p.population
            lblSurfaceWater.text = p.surface_water + "%"
            lblTerrain.text = p.terrain
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
