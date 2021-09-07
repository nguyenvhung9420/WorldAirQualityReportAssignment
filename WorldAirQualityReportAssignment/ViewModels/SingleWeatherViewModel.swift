//
//  SingleWeatherViewModel.swift
//  WorldAirQualityReportAssignment
//
//  Created by Hung Nguyen on 9/8/21.
//

import Foundation
import Combine
import Alamofire
import SwiftyJSON
import AlamofireURLCache5
import CoreLocation
import MapKit

class SingleWeatherViewModel: ObservableObject {
    private var currentLocation: CLLocation?
    private var service = WeatherService()
    @Published var currentCityString:String =  ""
    @Published var weather = Weather()
    @Published var dataListKeys: [String] = []
    @Published var currentMapLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    func getSingleWeather(failure: ((RequestError)->Void)?) {
       
        service.getSingleWeather(completion: { item, cityNameByCLLocation  in
            if failure != nil {
                failure!(RequestError(code: "", message: "", error: nil))
            }
            self.weather = item
            self.currentCityString = cityNameByCLLocation != "" ? cityNameByCLLocation : "Near your place"
        }, failure: { error in
            if failure != nil {
                failure!(error)
            }
        })
    }
    
    func getSingleWeatherByName(params: [String], failure: ((RequestError)->Void)?) {
        service.getSingleWeatherByname(params: params, completion: { item, cityNameByCLLocation  in
            if failure != nil {
                failure!(RequestError(code: "", message: "", error: nil))
            }
            self.weather = item
            self.currentCityString = cityNameByCLLocation != "" ? cityNameByCLLocation : "Near your place"
        }, failure: { error in
            if failure != nil {
                failure!(error)
            }
        })
    }
}
