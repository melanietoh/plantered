//
//  OpenWeatherCalls.swift
//  TohMelanieFinalProject
//
//  Created by Mel on 5/12/2022.
//

import Foundation

class OpenWeatherCalls {
    static let sharedInstance = OpenWeatherCalls()
    
    let API_KEY = "3fc8efe98a352d68386a7e9533da687f"
    var LAT = "0.0"
    var LON = "0.0"
    let BASE_URL = "https://api.openweathermap.org/data/2.5/weather?"
    var CALL_URL = ""
    
    let session = URLSession(configuration: .default)
    
    // Builds URL with user location information
    func getURL() -> String {
        CALL_URL = BASE_URL + "lat=" + LAT + "&lon=" + LON + "&appid=" + API_KEY + "&units=metric"
        
        return CALL_URL
    }
    
    // Setting lat variable
    func setLat(_ latitude: String) {
        LAT = latitude
    }
    
    // CoreLocationKit returns as a Double but URL requires String
    func setLat(_ latitude: Double) {
        setLat(String(latitude))
    }
    
    // Setting lon variable
    func setLon(_ longitude: String) {
        LON = longitude
    }
    
    // CoreLocationKit returns as a Double but URL requires String
    func setLon(_ longitude: Double) {
        setLon(String(longitude))
    }
    
    // Calls OpenWeather API
    func getWeather(onSuccess: @escaping (Result) -> Void,
                    onError: @escaping (String) -> Void) {
        guard let url = URL(string: getURL())
        else {
            onError("Error getting URL")
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }
                
                guard let data = data, let response = response as? HTTPURLResponse
                else {
                    onError("Data was invalid")
                    return
                }
                
                do {
                    // Successful retrieval
                    if response.statusCode == 200 {
                        let weather = try JSONDecoder().decode(Result.self, from: data)
                        onSuccess(weather)
                    }
                    else {
                        onError("Error \(response.statusCode)")
                    }
                }
                catch {
                    onError("JSON parsing error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}
