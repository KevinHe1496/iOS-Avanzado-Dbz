//
//  Location.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 25/10/24.
//

import Foundation
import MapKit

struct HeroLocation {
    let id: String
    let date: String?
    let latitude: String
    let longitude: String
    
    
    init(id: String, latitude: String, longitude: String, date: String?) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
    }
    
    init(moLocation: MOLocation) {
        self.id = moLocation.id ?? ""
        self.date = moLocation.date
        self.latitude = moLocation.latitude ?? ""
        self.longitude = moLocation.longitude ?? ""
    }
}


extension HeroLocation {
    var coordinate: CLLocationCoordinate2D? {
        guard let latitude = Double(self.latitude),
              let longitude = Double(self.longitude),
              abs(latitude) <= 90,
              abs(longitude) <= 180 else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
