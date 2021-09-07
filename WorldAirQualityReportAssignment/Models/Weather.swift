
import ObjectMapper
import Foundation

class Weather: Mappable {
    
    var cityName: String?
    var stateName: String?
    var countryName: String?
    
    var coords: [String] = []
    var forecast: [Forecast] = []
    var pollution: Pollution?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        cityName <- map["city"]
        stateName <- map["state"]
        countryName <- map["country"]
        coords <- map["location.coordinates"]
        
        forecast <- map["forecasts"]
        pollution <- map["current.pollution"]
    }
    
    var icon: String {
        return forecast[0].iconName ?? "10d"
    }
    
    //    {
    //      "status": "success",
    //      "data": {
    //        "city": "Port Harcourt",
    //        "state": "Rivers",
    //        "country": "Nigeria",
    //        "location": {
    //          "type": "Point",
    //          "location": [
    //            7.048623,
    //            4.854166
    //          ]
    //        },
    //        "forecasts": [
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
    //        ],
    //        "current": {
    //          "weather": {
    //            "ts": "2019-08-15T09:00:00.000Z",
    //            "tp": 23,
    //            "pr": 997,
    //            "hu": 100,
    //            "ws": 1,
    //            "wd": 216,
    //            "ic": "10d"
    //          },
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
    //        }
    //        }
    //      }
    //    }
}
