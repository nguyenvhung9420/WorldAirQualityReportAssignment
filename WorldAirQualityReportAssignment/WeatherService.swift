//
//  WeatherService.swift
//  WeatherWithNAB
//
//  Created by Hung Nguyen on 8/30/21.
//

import Foundation
import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON


class WeatherService {
    var api = Network()
    typealias ApiCompletion<T> = (T, String)->Void
    
    public func getSingleWeatherByname(params: [String], completion: @escaping ApiCompletion<Weather>, failure: @escaping (RequestError)->Void) {
        var url: URL?
        guard let locationBasedUrl = RequestURL(type: .weatherByCityName).getURL(params: params) else {
            failure(RequestError(code: "", message: "Unable to get cities of this city and/or this location.", error: nil))
            return
        }
        url = locationBasedUrl
      
        guard let finalUrl = url else {
            failure(RequestError(code: "", message: "Unable to get cities due to some problems.", error: nil))
            return
        }
        api.get(url: finalUrl, completion: { json in
            let json: JSON = json["data"]
            print(json)
            let weather: Weather = Weather(JSONString: json.description) ?? Weather()
            completion(weather, "\(weather.cityName)")
            
        }, failure: { error in
            failure(error)
        })
    }
    
    public func getSingleWeather(completion: @escaping ApiCompletion<Weather>, failure: @escaping (RequestError)->Void) {
        var url: URL?
        var currentLocation: CLLocation?
       
        let locManager = CLLocationManager()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways {
            currentLocation = locManager.location
        }
        if let lat = currentLocation?.coordinate.latitude, let long = currentLocation?.coordinate.longitude {
            guard let locationBasedUrl = RequestURL(type: .nearestCityByLatLon).getURL(params: ["\(lat)", "\(long)"]) else {
                print("Failed to get url with lat long: \([lat.string, long.string])")
                failure(RequestError(code: "", message: "Unable to get cities of this city and/or this location.", error: nil))
                return
            }
            url = locationBasedUrl
        }
      
        guard let finalUrl = url else {
            failure(RequestError(code: "", message: "Unable to get cities due to some problems.", error: nil))
            return
        }
        api.get(url: finalUrl, completion: { json in
            let json: JSON = json["data"]
            print(json)
            let weather: Weather = Weather(JSONString: json.description) ?? Weather()
            completion(weather, "\(weather.cityName)")
            
        }, failure: { error in
            failure(error)
        })
    }
    
    public func getCityList(params: [String], completion: @escaping ApiCompletion<[String]>, failure: @escaping (RequestError)->Void) {
        var url: URL?
        var requestType: RequestURLEnum =  .countryList
        switch params.count {
        case 0:
            requestType = .countryList
        case 1:
            requestType = .stateList
        case 2:
            requestType = .cityList
        default:
            requestType = .countryList
        }
        guard let locationBasedUrl = RequestURL(type: requestType).getURL(params: params) else {
            failure(RequestError(code: "", message: "Unable to get cities of this city and/or this location.", error: nil))
            return
        }
        url = locationBasedUrl
      
        guard let finalUrl = url else {
            failure(RequestError(code: "", message: "Unable to get cities due to some problems.", error: nil))
            return
        }
        api.get(url: finalUrl, completion: { json in
            let array: [String] = json["data"].arrayValue.map { eachJSON in
                if eachJSON.description.contains("city") {
                    return (City(JSONString: eachJSON.description) ?? City()).name
                } else if eachJSON.description.contains("country") {
                    return (Country(JSONString: eachJSON.description) ?? Country()).name
                } else if eachJSON.description.contains("state") {
                    return (CountryState(JSONString: eachJSON.description) ?? CountryState()).name
                } else {
                    return eachJSON.description
                }
            }
            print(array.map { return $0 })
            completion(array, "")
        }, failure: { error in
            failure(error)
        })
    }
}

fileprivate extension Double {
    var string: String {
        return String(describing: self)
    }
}

class RequestError: Error {
    var message: String = "Unknown error"
    var code: String = ""
    var error: NSError?
    
    init(code: String, message: String, error: NSError?) {
        self.code = code
        self.message = message
        if let _ = error {
            self.error = error
        }
    }
}

enum RequestURLEnum: String {
    
    case nearestCityByLatLon = "https://api.airvisual.com/v2/nearest_city?lat=%@&lon=%@&key="
    
    case cityList = "https://api.airvisual.com/v2/cities?state=%@&country=%@&key="
    case countryList = "https://api.airvisual.com/v2/countries?key="
    case stateList = "https://api.airvisual.com/v2/states?country=%@&key="
    case weatherIcon = "https://openweathermap.org/img/wn/%@@2x.png"
    
    case weatherByCityName = "http://api.airvisual.com/v2/city?city=%@&state=%@&country=%@&key="
}

class RequestURL {
    var requestType: RequestURLEnum?
    var apiKey: String {
        return "9d514f14-eec6-47c0-81e8-714a8d9f2c6e"
    }
    
    init(type: RequestURLEnum) {
        self.requestType = type
    }
    
    func getURL(params: [String] = [])  -> URL? {
      
            switch self.requestType {
            case .countryList:
                return URL(string: "\(self.requestType?.rawValue ?? "")\(self.apiKey)")
            case .stateList:
                if params.count >= 1 {
                    var str = String(format: self.requestType?.rawValue ?? "",
                                     params[0].replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil))
                    str = "\(str)\(self.apiKey)"
                    return URL(string: str)
                }
                return nil
            case .cityList:
                if params.count >= 1 {
                    var str = String(format: self.requestType?.rawValue ?? "",
                                     params[1].replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil),
                                     params[0].replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil) )
                    str = "\(str)\(self.apiKey)"
                    print("Gettng city in state by url: \(str)")
                    return URL(string: str)
                }
                return nil
            case .nearestCityByLatLon:
                if !(params.count >= 2) {
                    return nil
                }
                let lat = params[0]
                let long = params[1]
                let str = String(format: self.requestType?.rawValue ?? "", lat, long)
                return URL(string: str)
            case .weatherByCityName:
                if !(params.count >= 3) {
                    return nil
                }
                var str = String(format: self.requestType?.rawValue ?? "",
                                 params[2].replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil),
                                 params[1].replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil),
                                 params[0].replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil))
                str = "\(str)\(self.apiKey)"
                return URL(string: str)
            default:
                return nil
            }
        
    }
}
