//
//  DetailViewController.swift
//  URLSession
//
//  Created by  on 10/4/20.
//  Copyright © 2020 jonathan. All rights reserved.
//

import UIKit
import WebKit
import PocketSVG

class DetailViewController: UIViewController {
    
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var capital: UILabel!
    @IBOutlet weak var population: UILabel!
    
    @IBOutlet weak var flagWebView: WKWebView!
    
    var country: Country? {
        didSet {
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        

        
        if let country = country,
            let countryName = countryName,
            let flag = flag,
            let capital = capital,
            let population = population {
            
            guard let countryFlagURL = URL(string: country.flag) else {
                return
            }
            
            let svgImageView = SVGImageView.init(contentsOf: countryFlagURL)
            svgImageView.frame = flag.frame
            view.addSubview(svgImageView)
            
            countryName.text = country.name
            capital.text = country.capital
            population.text = String (country.population)
            
            if (country.population > 10000000) {
                population.textColor = UIColor.blue
            }
        }
    }
    
}
