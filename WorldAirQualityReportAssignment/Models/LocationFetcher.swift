//
//  LocationFetcher.swift
//  WeatherWithNAB
//
//  Created by Hung Nguyen on 9/2/21.
//

import Foundation
import CoreLocation


class LocationFetcher: NSObject, CLLocationManagerDelegate {
    static let shared = LocationFetcher()
    let manager = CLLocationManager()
    var lastKnownLocation: CLLocationCoordinate2D?
    var onAccept: (()->Void)?

    override init() {
        super.init()
        manager.delegate = self
    }

    func start(_ onAccept: @escaping ()->Void) {
        print("It comes here manager.requestWhenInUseAuthorization()")
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        self.onAccept = onAccept
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status ==  .authorizedAlways {
            if self.onAccept != nil {
                self.onAccept!()
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
}

import MapKit
import Contacts

extension CLPlacemark {
    /// street name, eg. Infinite Loop
    var streetName: String? { thoroughfare }
    /// // eg. 1
    var streetNumber: String? { subThoroughfare }
    /// city, eg. Cupertino
    var city: String? { locality }
    /// neighborhood, common name, eg. Mission District
    var neighborhood: String? { subLocality }
    /// state, eg. CA
    var state: String? { administrativeArea }
    /// county, eg. Santa Clara
    var county: String? { subAdministrativeArea }
    /// zip code, eg. 95014
    var zipCode: String? { postalCode }
    /// postal address formatted
    @available(iOS 11.0, *)
    var postalAddressFormatted: String? {
        guard let postalAddress = postalAddress else { return nil }
        return CNPostalAddressFormatter().string(from: postalAddress)
    }
}

extension CLLocation {
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}


