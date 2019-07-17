//
//  Observation.swift
//  ThailandWeather
//
//  Created by T2P mac mini on 17/7/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import UIKit

class Observation: NSObject {

    var strDateTime:String = ""
    var dateTime:Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        
        if let date = dateFormatter.date(from: self.strDateTime){
           return date
        }else{
            return nil
        }
    }
    
    var stationPressure:Observalue = Observalue()
    var meanSeaLevelPressure:Observalue = Observalue()
    var airTemperature:Observalue = Observalue()
    var dewPoint:Observalue = Observalue()
    var relativeHumidity:Observalue = Observalue()
    
    var vaporPressure:Observalue = Observalue()
    var landVisibility:Observalue = Observalue()
    var windDirection:Observalue = Observalue()
    var windSpeed:Observalue = Observalue()
    var rainfall:Observalue = Observalue()
    var rainfall24Hr:Observalue = Observalue()
}
