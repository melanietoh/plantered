//
//  Weather.swift
//  TohMelanieFinalProject
//
//  Created by Mel on 5/12/2022.
//


import Foundation

// JSON fields from OpenWeather API 
class Result: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let dt: TimeInterval
    let sys: Sys
    let timezone: Int
    let name: String
}

class Coord: Codable {
    let lon: Double
    let lat: Double
}

class Weather: Codable {
    let id: Int
    let description: String
    let icon: String
}

class Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let humidity: Double
}

class Wind: Codable {
    let speed: Double
}

class Sys: Codable {
    let country: String
}
