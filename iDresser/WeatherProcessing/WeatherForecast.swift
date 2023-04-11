//
//  WeatherForecast.swift
//  WeatherForecast
//
//  Created by Kateryna Avramenko on 05.03.23.
//

import Foundation

struct WeatherApiResponse: Codable {
    let main: Main
    let rain: Rain?
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let humidity: Int
}

struct Rain: Codable {
    let oneHour: Double
       
       enum CodingKeys: String, CodingKey {
           case oneHour = "1h"
       }
}

struct Weather: Codable {
    let icon: String
}
