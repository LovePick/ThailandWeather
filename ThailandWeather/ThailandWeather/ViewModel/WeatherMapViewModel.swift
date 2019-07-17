//
//  WeatherMapViewModel.swift
//  ThailandWeather
//
//  Created by T2P mac mini on 17/7/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import UIKit

class WeatherMapViewModel: NSObject {

    private let apiService = APIServices()
    
    
    var arStation:[WeatherStation] = [WeatherStation]()
    
    func loadData(completion:@escaping (Error?)->Void){
        apiService.getWeather { (arWeather, error) in
            
            guard let arWeather = arWeather else {
                completion(error)
                return
            }
            self.arStation = arWeather
            completion(error)
           
        }
    }
    
    
    
}
