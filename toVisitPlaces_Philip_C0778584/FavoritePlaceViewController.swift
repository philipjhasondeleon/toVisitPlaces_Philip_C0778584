//
//  FavoritePlaceViewController.swift
//  toVisitPlaces_Philip_C0778584
//
//  Created by user175490 on 6/18/20.
//  Copyright © 2020 user175490. All rights reserved.
//

import UIKit
import MapKit

class FavoritePlaceViewController: UIViewController, MKMapViewDelegate  {

        @IBOutlet weak var editMap: MKMapView!
        let defaults = UserDefaults.standard
        var lat : Double = 0.0
        var long : Double = 0.0
        var drag : Bool? = false
        var editedPlace : Int = 0
        var editPlaces : [Places]?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            editMap.delegate = self
             self.navigationController?.view.tintColor = .systemBlue
    //        self.navigationItem.leftBarButtonItem?.title = "Back"
            self.navigationItem.title = "Edit your location"
            
            let backButton = UIBarButtonItem()
            backButton.title = "Back"
            self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
                   
            
            self.editedPlace = defaults.integer(forKey: "edit")
                    
            self.editMap.addAnnotation(dragablePin())
            let latDelta: CLLocationDegrees = 0.05
            let longDelta: CLLocationDegrees = 0.05
             
             // 3 - Creating the span, location coordinate and region
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
            let customLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let region = MKCoordinateRegion(center: customLocation, span: span)
                   
             // 4 - assign region to map
            editMap.setRegion(region, animated: true)
            
            loadData()
        
        }
        
       func dragablePin() -> MKPointAnnotation{
        self.lat = defaults.double(forKey: "latitude")
        self.long = defaults.double(forKey: "longitude")
        
        self.drag = defaults.bool(forKey: "bool")
        
        print("Lat: \(lat): Long: \(long)")
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)
    //    annotation.title = "Your Favourite Location"
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: lat, longitude: long)) { (placemarks, error) in
            if let places = placemarks {
                for place in places {
                    annotation.title = place.name
                    annotation.subtitle = "\(place.locality!) ,  \(place.postalCode!)"
                }
            }
        }
        //        self.mapView.addAnnotation(annotation)
        return annotation
        
        
        }
         
            func getDataFilePath() -> String {
                   let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                   let filePath = documentPath.appending("/places-data.txt")
                   return filePath
               }
            
            func loadData() {
                self.editPlaces = [Places]()
                
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
                                self.editPlaces?.append(place)
                            }
                    }
                       
        //                print(self.places?.count)
                    }
                    catch{
                        print(error)
                    }
                }
            }
            
            func editLocation() {
                let filePath = getDataFilePath()

                var saveString = ""
                for place in self.editPlaces!{
                   saveString = "\(saveString)\(place.placeLat),\(place.placeLong),\(place.placeName),\(place.city),\(place.country),\(place.postalCode)\n"
                    do{
                   try saveString.write(toFile: filePath, atomically: true, encoding: .utf8)
                    }
                    catch{
                        print(error)
                    }
                }
            }

    }

    extension FavoritePlaceViewController{
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
      
            let pinAnnotation = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker")
                    pinAnnotation.markerTintColor = .systemBlue
                    pinAnnotation.glyphTintColor = .white
                    pinAnnotation.isDraggable = true
                    pinAnnotation.canShowCallout = true
                    pinAnnotation.rightCalloutAccessoryView = UIButton(type: .contactAdd)
                    return pinAnnotation
        
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
                let alertController = UIAlertController(title: "Add to Favourites", message:
                    "Are you sure to change this location?", preferredStyle: .actionSheet)
               alertController.addAction(UIAlertAction(title: "Yes", style:  .default, handler: { (UIAlertAction) in
                   
                CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: mapView.annotations[0].coordinate.latitude, longitude: mapView.annotations[0].coordinate.longitude)) {  placemark, error in
                           if let error = error as? CLError {
                               print("CLError:", error)
                               return
                            }
                           else if let placemark = placemark?[0] {
                            
                            var placeName = ""
                            var neighbourhood = ""
                            var city = ""
                            var state = ""
                            var postalCode = ""
                            var country = ""
                            
                            
                            if let name = placemark.name {
                                placeName += name
                                        }
                            if let sublocality = placemark.subLocality {
                                neighbourhood += sublocality
                                        }
                            if let locality = placemark.subLocality {
                                 city += locality
                                        }
                            if let area = placemark.administrativeArea {
                                          state += area
                                      }
                            if let code = placemark.postalCode {
                                          postalCode += code
                                      }
                            if let cntry = placemark.country {
                                                    country += cntry
                                                }
                //          print(placeName ,city, state, postalCode , country)
                            
                            
                            let place = Places(placeLat:  mapView.annotations[0].coordinate.latitude, placeLong: mapView.annotations[0].coordinate.longitude, placeName: placeName, city: city, postalCode: postalCode, country: country)
                          
                //          print(placeName ,city, state, postalCode , country, self.destinationCoordinates.latitude, self.destinationCoordinates.longitude)
                            self.editPlaces?.remove(at: self.editedPlace)
                            self.editPlaces?.append(place)
                            
                            self.editLocation()
    //                        self.saveData()
                            self.navigationController?.popToRootViewController(animated: true)

                //
                //                print("name:", placemark.name ?? "unknown")
                //                print("neighborhood:", placemark.subLocality ?? "unknown")
                //                print("city:", placemark.locality ?? "unknown")
                //                print("state:", placemark.administrativeArea ?? "unknown")
                //                print("zip code:", placemark.postalCode ?? "unknown")
                //                print("country:", placemark.country ?? "unknown", terminator: "\n\n")
                            
                            
                               
                            }
                        
                        }
                   
               }))
           
               alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                   self.present(alertController, animated: true, completion: nil)
                           
           }


    }
