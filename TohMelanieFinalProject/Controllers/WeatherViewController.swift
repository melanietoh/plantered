//
//  WeatherViewController.swift
//  TohMelanieFinalProject
//
//  Created by Mel on 5/12/2022.
//

import Foundation
import UIKit
import MapKit
import EventKit
import EventKitUI

class WeatherViewController: UIViewController, CLLocationManagerDelegate, EKEventEditViewDelegate {
    
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var reminderButton: UIButton!
    
    // Location-related properties and delegate methods.
    let locationManager = CLLocationManager()
    var lat: Double = 0.0
    var lon: Double = 0.0
    var currentLocation: CLLocation?
    var currentWeather: Result?
    let sharedInstance = OpenWeatherCalls.sharedInstance
    
    var date: String = ""
    var city: String = "Los Angeles"
    var humidity: Int = 0
    var weather: String = ""
    
    // Event-related
    let eventStore = EKEventStore()
    var time = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Rounded corners for weatherView and button
        weatherView.layer.cornerRadius = 10
        weatherView.layer.masksToBounds = true
        reminderButton.layer.cornerRadius = 10
        weatherView.layer.masksToBounds = true
        
        // Set location values
        getCurrentLocation()
    }
    
    // Requests user location
    func getCurrentLocation() {
        if(CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        }
        else {
            print("Location services are not enabled")
        }
    }
    
    // Converts user location coordinates to city name
    func getCurrentCity(completionHandler: @escaping (CLPlacemark?)
                    -> Void ) {
        // Use the last reported location.
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
                
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                        completionHandler: { (placemarks, error) in
                if error == nil {
                    let placemark = placemarks?[0]
                    completionHandler(placemark)
                }
                else {
                 // An error occurred during geocoding.
                    completionHandler(nil)
                }
            })
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }
    
    // Stores user location and calls OpenWeatherAPI
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Retrieve user's current location
        if let location = locations.last {
            self.currentLocation = location
            self.lat = self.currentLocation!.coordinate.latitude
            self.lon = self.currentLocation!.coordinate.longitude
            
            sharedInstance.setLat(lat)
            sharedInstance.setLon(lon)
            
            // Retrieve city
            getCurrentCity(completionHandler: { (placemark) in
                guard let placemark = placemark
                else {
                    return
                }
                
                self.city = placemark.locality!
            })
        }
        
        // Retrieve weather from OpenWeather API
        sharedInstance.getWeather(onSuccess: { (result) in
            self.currentWeather = result
        }) { (errorMessage) in
            debugPrint(errorMessage)
        }
    }
    
    // Error handling
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
    
    // Updating all weather-related labels
    func updateLabels() {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        date = formatter.string(from: Date())
        
        guard let currentWeather = currentWeather else {
            print("Error retrieving weather")
            return
        }

        dateLabel.text = date
        cityLabel.text = city
        weatherImage.image = UIImage(named: currentWeather.weather[0].icon)
        humidityLabel.text = "Humidity: " + String(currentWeather.main.humidity) + "%"
        weatherLabel.text = currentWeather.weather[0].description.capitalized
    }
    
    // Calls OpenWeatherAPI to get current weather + updates labels
    @IBAction func refreshPressed(_ sender: UIBarButtonItem) {
        getCurrentLocation()
        updateLabels()
    }
    
    // Creates a calendar event
    @IBAction func setReminder(_ sender: UIButton) {
        eventStore.requestAccess(to: EKEntityType.event, completion:{(granted, error) in
            DispatchQueue.main.async {
                if (granted) && (error == nil) {
                    let event = EKEvent(eventStore: self.eventStore)
                    event.title = "Water plants"
                    event.startDate = self.time
                    event.endDate = self.time
                    let eventController = EKEventEditViewController()
                    eventController.event = event
                    eventController.eventStore = self.eventStore
                    eventController.editViewDelegate = self
                    self.present(eventController, animated: true, completion: nil)
                }
            }
        })
    }
    
    // EventKit protocol stub
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
}
