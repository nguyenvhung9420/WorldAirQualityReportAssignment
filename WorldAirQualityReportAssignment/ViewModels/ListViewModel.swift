//
//  WeatherListViewModel.swift
//  WeatherWithNAB
//
//  Created by Hung Nguyen on 8/28/21.
//

import Foundation
import Combine
import Alamofire
import SwiftyJSON
import AlamofireURLCache5
import CoreLocation
import MapKit

class ListViewModel: ObservableObject{
    private var currentLocation: CLLocation?
    
    private var service = WeatherService()
    @Published var isGettingType: String =  ""
    @Published var currentCityString:String =  ""
    @Published var list: [String] = []
    
    func getLocationList(params: [String], count: Int = 10, failure: ((RequestError)->Void)?) {
        switch params.count {
        case 0:
            isGettingType = "countries"
        case 1:
            isGettingType = "states"
        case 2:
            isGettingType = "cities"
        default:
            isGettingType = "countries"
        }
        service.getCityList(params: params, completion: { items, cityNameByCLLocation  in
            if failure != nil {
                failure!(RequestError(code: "", message: "", error: nil))
            }
            self.list = items
            self.currentCityString = cityNameByCLLocation != "" ? cityNameByCLLocation : "Near your place"
        }, failure: { error in
            if failure != nil {
                failure!(error)
            }
        })
    }
}
