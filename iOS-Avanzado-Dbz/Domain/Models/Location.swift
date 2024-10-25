//
//  Location.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 25/10/24.
//

import Foundation
import MapKit

struct Location {
    let id: String
    let date: String
    let latitude: String
    let longitude: String
    
    init(moLocation: MOLocation) {
        self.id = moLocation.id ?? ""
        self.date = moLocation.date ?? ""
        self.latitude = moLocation.latitude ?? ""
        self.longitude = moLocation.longitude ?? ""
    }
}


extension Location {
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
