//
//  Observalue.swift
//  ThailandWeather
//
//  Created by T2P mac mini on 17/7/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import UIKit

class Observalue {
    var value:Double = 0
    var unit:String = ""
    
    init(){
        
    }
    
    
    convenience init(value:String, attributeDict:[String:String]?){
        self.init()
        
        self.value = Double(value) ?? 0.0
        
        if let attribute = attributeDict{
            if let unit = attribute["Unit"]{
                self.unit = unit
            }else if let unit = attribute["unit"]{
                self.unit = unit
            }
        }
    }
}
