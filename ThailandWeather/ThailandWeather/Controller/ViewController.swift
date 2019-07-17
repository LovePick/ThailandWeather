//
//  ViewController.swift
//  ThailandWeather
//
//  Created by T2P mac mini on 17/7/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController {

    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btReload: UIButton!
    
    
    private let weatherViewModel:WeatherMapViewModel = WeatherMapViewModel()
    private var arPin:[MKPointAnnotation] = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.loadWeatherData()
        
    }

    
    
    @IBAction func tapOnReload(_ sender: Any) {
        self.loadWeatherData()
    }
    
    
    func loadWeatherData() {
        weatherViewModel.loadData { (error) in
            
            if let error = error{
                self.alertWith(message: error.localizedDescription)
            }
            
            self.reloadMap()
        }
    }
    
    
    func reloadMap() {
        
        self.mapView.removeAnnotations(self.arPin)
        self.arPin.removeAll()
        
        
        for item in self.weatherViewModel.arStation{
            let pin = self.pinWith(station: item)
            self.arPin.append(pin)
        }
        
        self.mapView.showAnnotations(self.arPin, animated: true)
    
    }
    
    
    func pinWith(station:WeatherStation)->MKPointAnnotation{
        
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: station.latitude.value, longitude:station.longitude.value)
        annotation.coordinate = centerCoordinate
        
        let strTitle:String = "\(station.stationNameThai) \(station.observation.airTemperature.value) \(station.observation.airTemperature.unit.capitalized)"
        annotation.title = strTitle
        print(strTitle)
        return annotation
    }
    
    
    
    func alertWith(message:String){
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let atitle:String =  NSLocalizedString("OK", comment: "")
        let cancelAction = UIAlertAction(title: atitle, style: .cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
   
}


extension ViewController:MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        annotationView?.displayPriority = .required
        
        return annotationView
    }
}
