//
//  NetworkService.swift
//  iDresser
//
//  Created by Kateryna Avramenko on 07.04.2023.
//

import Foundation

let apiKey = "3b80982d4cc4d739f236ec05272fa4bd"

class NetworkService {
    
    func fetchWeatherData(lat: Double, lon: Double, completion: @escaping (WeatherApiResponse?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                
                do {
                    let weatherData = try decoder.decode(WeatherApiResponse.self, from: data)
                    completion(weatherData)
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(nil)
                }
            } else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
        
        task.resume()
    }

}
