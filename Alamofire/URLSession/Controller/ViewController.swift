//
//  ViewController.swift
//  URLSession
//
//  Created by  on 6/4/20.
//  Copyright © 2020 jonathan. All rights reserved.
//

import UIKit
import Alamofire
import JavaScriptCore

struct Connectivity {
  static let sharedInstance = NetworkReachabilityManager()!
  static var isConnectedToInternet:Bool {
      return self.sharedInstance.isReachable
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var countries: [Country] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Connectivity.isConnectedToInternet {
             print("Connected")
         } else {
            let alert = UIAlertController(title: "No Internet Connection", message: "Please turn on your network.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

            self.present(alert, animated: true)
             print("No Internet")
        }
        
        // Do any additional setup after loading the view.
//        fetchURL(url: "https://restcountries.eu/rest/v2/all")
        getCountryData(url: "https://restcountries.eu/rest/v2/all")
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      if let indexPath = tableView.indexPathForSelectedRow {
        tableView.deselectRow(at: indexPath, animated: true)
      }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("PREPARE")
        guard
            segue.identifier == "ShowDetailSegue",
            let indexPath = tableView.indexPathForSelectedRow,
            let detailViewController = segue.destination as? DetailViewController
            else {
                return
            }
        
        let country: Country
        country = countries[indexPath.row]
        detailViewController.country = country
    }
    
    func getCountryData(url: String) {
        let request = Alamofire.request(url).validate()
        request.responseJSON { response in
            guard let data = response.data else {
                print("No Data")
                return
            }
            do {
                let decoder = JSONDecoder()
                let countriesData = try decoder.decode([Country].self, from: data)
                self.countries = countriesData
                
                //reloads the data in the main queue
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
           } catch {
                print(error)
           }
        }
    }

    func fetchURL(url: String) {
        if let urlToServer = URL.init(string: url) {
            let task = URLSession.shared.dataTask(with: urlToServer, completionHandler: {(data, response, error) in
                if error != nil || data == nil {
                    //handle error
                }
                else {
                    do {
                        let jsonData = try JSONDecoder().decode([Country].self, from: data!)
                        print(jsonData)
                        self.countries = jsonData
                        
                        //reloads the data in the main queue
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } catch {
                        print(error)
                    }
                }
            })
            task.resume()
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("AT DEQUEUE")
        let cellIdentifier = "CountryTableViewCell"

        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let country: Country
        
        country = countries[indexPath.row]
    
        cell.textLabel?.text = country.name

        return cell
    }
}
