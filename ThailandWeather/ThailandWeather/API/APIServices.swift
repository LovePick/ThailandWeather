//
//  APIServices.swift
//  ThailandWeather
//
//  Created by T2P mac mini on 17/7/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import UIKit

class APIServices:NSObject {

    struct XMLParsingError: Error {
        enum ErrorKind {
            case invalidCharacter
            case mismatchedTag
            case internalError
            case dataIsNil
        }
        let kind: ErrorKind
    }
    
    
    
    let weather3HoursURL:String = "https://data.tmd.go.th/api/Weather3Hours/V2/?uid=api&ukey=api12345"
    
    
    
    var arStation:[WeatherStation] = [WeatherStation]()
    
    var currentStation:WeatherStation? = nil
    
    
    var currentValue:String? = nil
    var currentAttributeDict:[String : String]? = nil
    
    
    var completionHandle:( _ stations:[WeatherStation]?, _ error: Error?)->Void = {(_,_) in }
    
    
   
    
    override init() {
        super.init()
     
    }
   
    
    
    
    func getWeather(completion: @escaping ( _ stations:[WeatherStation]?, _ error: Error?)->Void){
        
        self.arStation.removeAll()
        
        getDataFromURL(urlString: weather3HoursURL) { (result, error) in
            
            if let result = result{
                self.completionHandle = completion
                let parser = XMLParser(data: result)
                parser.delegate = self
                parser.parse()
            }else{
                
                completion(nil, XMLParsingError(kind: .dataIsNil))
            }
            
            
        }
    }
    
    
    
}


extension APIServices{
    private func getDataFromURL(urlString: String, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Error: Cannot create URL from string")
            return
        }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            guard error == nil else {
                print("Error calling api")
                return completion(nil, error)
            }
            guard let responseData = data else {
                print("Data is nil")
                return completion(nil, error)
            }
            completion(responseData, nil)
        }
        task.resume()
    }
}




extension APIServices: XMLParserDelegate{
    
    func parserDidStartDocument(_ parser: XMLParser) {
        //print("parserDidStartDocument")
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        

        self.currentValue = String()
        self.currentAttributeDict = attributeDict
        if elementName == "Station"{
            self.currentStation = WeatherStation()
        }
        
        //print("didStartElement \(elementName)")
    }
    

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if self.currentValue != nil{
            self.currentValue! += string
            //print("foundCharacters : \(self.currentValue!)")
        }
    
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
       //print("didEndElement \(elementName)")
        guard let station =  self.currentStation else {
          
            return
        }
        
        if(elementName == "Station"){
            self.arStation.append(station)
            self.currentStation = nil
            self.currentValue = nil
            self.currentAttributeDict = nil
            return
        }
        
        
        
        guard let value = self.currentValue else {
           
            return
        }
        
        //print("didEndElement : \(elementName)")
        
        switch elementName {
        case "WmoStationNumber":
            station.wmoStationNumber = NSInteger(value) ?? 0
            break
        case "StationNameThai":
            station.stationNameThai = value
            break
        case "StationNameEnglish":
            station.stationNameEnglish = value
            break
        case "Province":
            station.province = value
            break
        case "Latitude":
            station.latitude = Observalue(value: value, attributeDict: self.currentAttributeDict)
            break
        case "Longitude":
            station.longitude = Observalue(value: value, attributeDict: self.currentAttributeDict)
            break
        case "DateTime":
            station.observation.strDateTime = value
            
            break
        case "StationPressure":
            station.observation.stationPressure = Observalue(value: value, attributeDict: self.currentAttributeDict)
            break
        case "MeanSeaLevelPressure":
            station.observation.meanSeaLevelPressure = Observalue(value: value, attributeDict: self.currentAttributeDict)
            break
        case "AirTemperature":
            station.observation.airTemperature = Observalue(value: value, attributeDict: self.currentAttributeDict)
            break
        case "DewPoint":
            station.observation.dewPoint = Observalue(value: value, attributeDict: self.currentAttributeDict)
            break
        case "RelativeHumidity":
            station.observation.relativeHumidity = Observalue(value: value, attributeDict: self.currentAttributeDict)
            break
        case "VaporPressure":
            station.observation.vaporPressure = Observalue(value: value, attributeDict: self.currentAttributeDict)
            break
        case "LandVisibility":
            station.observation.landVisibility = Observalue(value: value, attributeDict: self.currentAttributeDict)
            break
        case "WindDirection":
            station.observation.windDirection = Observalue(value: value, attributeDict: self.currentAttributeDict)
            break
        case "WindSpeed":
            station.observation.windSpeed = Observalue(value: value, attributeDict: self.currentAttributeDict)
            break
        case "Rainfall":
            station.observation.rainfall = Observalue(value: value, attributeDict: self.currentAttributeDict)
            break
        case "Rainfall24Hr":
            station.observation.rainfall24Hr = Observalue(value: value, attributeDict: self.currentAttributeDict)
            break
        default:
            break
        }
        

        self.currentValue = nil
        self.currentAttributeDict = nil
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        //print("parserDidEndDocument")
        
        self.completionHandle(self.arStation, nil)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.completionHandle(nil, parseError)
    }
    
    
    
    
}
