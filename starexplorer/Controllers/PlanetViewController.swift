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
            if p.rotation_period != "unknown" && p.rotation_period != "N/A" {
                lblRotationPeriod.text = (Int(p.rotation_period)?.formattedWithSeparator)! + " hours"
            }else{
                lblRotationPeriod.text = p.rotation_period
            }
            if p.orbital_period != "unknown" && p.orbital_period != "N/A" {
                lblOrbitalPeriod.text = (Int(p.orbital_period)?.formattedWithSeparator)! + " days"
            }else{
                lblOrbitalPeriod.text = p.orbital_period
                
            }
            if p.diameter != "unknown" && p.diameter != "N/A" {
                lblDiameter.text = (Int(p.diameter)?.formattedWithSeparator)! + " km"
            }else{
                lblDiameter.text = p.diameter
                
            }
            if p.gravity == "1"{
                lblGravity.text = p.gravity + " G"
            }
            else if p.gravity != "unknown" && p.gravity != "N/A" {
                lblGravity.text = p.gravity + " Gs"
            }else{
                lblGravity.text = p.gravity
                
            }
            if p.population != "unknown" && p.population != "N/A" {
                lblPopulation.text = (Int(p.population)?.formattedWithSeparator)!
            }else{
                lblPopulation.text = p.population
                
            }
            if p.surface_water != "unknown" && p.surface_water != "N/A" {
                lblSurfaceWater.text = (Int(p.surface_water)?.formattedWithSeparator)! + "%"
            }else{
                lblSurfaceWater.text = p.surface_water
                
            }
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
