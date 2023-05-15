//
//  LocationManager.swift
//  iDresser
//
//  Created by Kateryna Avramenko on 07.04.2023.
//

import SwiftUI
import CoreLocation
import Foundation

struct LocationRepr {
    let title: String
    let coordinates: CLLocationCoordinate2D?
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location: CLLocation?
    let locationManager = CLLocationManager()
    static let shared = LocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    public func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }

    public func getCityCountry(completion: @escaping (String?, String?, Error?) -> ()) {
        guard let location = self.location else {
            completion(nil, nil, NSError(domain: "LocationManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Location is not available"]))
            return
        }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                completion(nil, nil, error)
            } else {
                let placemark = placemarks?.first
                let city = placemark?.locality
                let country = placemark?.country
                completion(city, country, nil)
            }
        }
    }
}

