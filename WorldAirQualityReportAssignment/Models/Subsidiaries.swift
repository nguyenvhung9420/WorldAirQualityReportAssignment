//
//  Weather.swift
//  WorldAirQualityReportAssignment
//
//  Created by Hung Nguyen on 9/3/21.
//

import Foundation
import ObjectMapper

class Forecast: Mappable {
    var iconName: String?
    var w3sTimeString: String?
    var pressure: String?
    var humidity: String?
    var windSpeed: String?
    var windDirection: Int?
    var aqius: Int?
    var aqicn: Int?
    var tp: Int?
    var tp_min: Int?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        iconName <- map["ic"]
        w3sTimeString <- map["ts"]
        pressure <- map["pr"]
        humidity <- map["hu"]
        windSpeed <- map["ws"]
        windDirection <- map["wd"]
        
        aqius <- map["aqius"]
        aqicn <- map["aqicn"]
        tp <- map["tp"]
        tp_min <- map["tp_min"]
    }
    
    //          {
    //            "ts": "2019-08-15T12:00:00.000Z",
    //            "aqius": 137,
    //            "aqicn": 69,
    //            "tp": 23,
    //            "tp_min": 23,
    //            "pr": 996,
    //            "hu": 100,
    //            "ws": 2,
    //            "wd": 225,
    //            "ic": "10d"
    //          }
}

class Pollution: Mappable {
    var w3sTimeString: String?
    var aqius: Int?
    var aqicn: Int?
    var mainus: Int?
    var maincn: Int?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        w3sTimeString <- map["ts"]
        aqius <- map["aqius"]
        mainus <- map["mainus"]
        aqicn <- map["aqicn"]
        maincn <- map["maincn"]
    }
    
    //          "pollution": {
    //            "ts": "2019-08-15T10:00:00.000Z",
    //            "aqius": 83,
    //            "mainus": "p2",
    //            "aqicn": 39,
    //            "maincn": "p2",
    //            "p2": {
    //              "conc": 27.2,
    //              "aqius": 83,
    //              "aqicn": 39
    //            }
    //          }
}
