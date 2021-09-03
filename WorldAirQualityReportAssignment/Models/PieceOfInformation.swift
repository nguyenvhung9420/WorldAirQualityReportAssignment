//
//  PieceOfInformation.swift
//  WeatherWithNAB
//
//  Created by Hung Nguyen on 8/28/21.
//

import Foundation
import Combine
import ObjectMapper

class Country: Mappable {
    var name: String = ""
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        name <- map["country"]
    }
}

class City: Mappable {
    var name: String = ""
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        name <- map["city"]
    }
}

class CountryState: Mappable {
    var name: String = ""
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        name <- map["state"]
    }
}

//class City: Mappable {
//    var dt: Int?
//    var dateInterval: Int?
//    var avgTemp: Temperature? // always in Celsius
//    var pressure: Int = 1
//    var humid: Double = 0.0
//    var description: String?
//    var icon: String = ""
//
//    init() {}
//
//    required init?(map: Map) {}
//
//    func mapping(map: Map) {
//        dt <- map["dt"]
//        description <- map["weather.0.description"]
//        icon <- map["weather.0.icon"]
//        avgTemp <- map["temp"]
//        pressure <- map["pressure"]
//        humid <- map["humidity"]
//        dateInterval <- map["dt"]
//    }
//
//    var id: String {
//        guard let dt = self.dt else {
//            return ""
//        }
//        return String(describing: dt)
//    }
//
//    var date: Date {
//        let date = Date(timeIntervalSince1970: Double(self.dateInterval ?? 0))
//        return date
//    }
//
//    var dateString: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEE, dd MMM, yyyy"
//        return formatter.string(from: self.date)
//    }
//
//    var averageTempString: String {
//        return String(format: "%.2f°C", self.avgTemp?.day ?? 0.0)
//    }
//}

class Temperature: Mappable {
    var day: Double?
    var min: Double?
    var max: Double?
    var night: Double?
    var morning: Double?
    
    init() {}
    
    required init?(map: Map) {}

    // Mappable
    func mapping(map: Map) {
        day <- map["day"]
        min <- map["min"]
        max <- map["max"]
        night <- map["night"]
        morning <- map["morn"]
    }
}
