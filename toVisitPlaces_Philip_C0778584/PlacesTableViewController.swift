//
//  PlacesTableViewController.swift
//  toVisitPlaces_Philip_C0778584
//
//  Created by user175490 on 6/18/20.
//  Copyright © 2020 user175490. All rights reserved.
//

import UIKit

class PlacesTableViewController: UITableViewController {
    
    var places : [Places]?
    
    var deleteArray : [Places]?
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
          self.navigationController?.view.tintColor = .systemPink
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        self.tableView.reloadData()
        
    }
    
    func getDataFilePath() -> String {
           let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
           let filePath = documentPath.appending("/places-data.txt")
           return filePath
       }
    
    func loadData() {
        places = [Places]()
        
        let filePath = getDataFilePath()
        
        if FileManager.default.fileExists(atPath: filePath){
            do{
                //creating string of file path
             let fileContent = try String(contentsOfFile: filePath)
                
                let contentArray = fileContent.components(separatedBy: "\n")
                for content in contentArray{
                   
                    let placeContent = content.components(separatedBy: ",")
                    if placeContent.count == 6 {
                        let place = Places(placeLat: Double(placeContent[0]) ?? 0.0, placeLong: Double(placeContent[1]) ?? 0.0, placeName: placeContent[2], city: placeContent[3], postalCode: placeContent[4], country: placeContent[5])
                        places?.append(place)
                    }
            }
            }
            catch{
                print(error)
            }
        }
    }
    
    func deleteRow() {
        let filePath = getDataFilePath()

        var saveString = ""
        for place in self.deleteArray!{
           saveString = "\(saveString)\(place.placeLat),\(place.placeLong),\(place.placeName),\(place.city),\(place.country),\(place.postalCode)\n"
            do{
           try saveString.write(toFile: filePath, atomically: true, encoding: .utf8)
            }
            catch{
                print(error)
            }
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
       return "Your Favourite Places are:"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let place = self.places![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell")
        cell?.textLabel?.text = place.placeName + " , " + place.city
        cell?.detailTextLabel?.text = place.country + " , " + place.postalCode

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let editedPlace =  self.places![indexPath.row]
        
        defaults.set(editedPlace.placeLat, forKey: "latitude")
        defaults.set(editedPlace.placeLong, forKey: "longitude")
        defaults.set(true, forKey: "bool")
        defaults.set(indexPath.row, forKey: "edit")
        
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "newVC") as! FavoritePlaceViewController
        self.navigationController?.pushViewController(newVC, animated: true)

    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
        if editingStyle == .delete {
            
            self.places?.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            self.deleteArray = self.places
            deleteRow()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }


}
