//
//  WeatherData.swift
//  BostaAssessment
//
//  Created by Hazem Abou El Fadl on 27/02/2025.
//

import Foundation

struct UsersData: Codable{
    let name:String
    let address:Address
}

struct Address: Codable{
    let street:String
    let suite:String
    let city:String
    let zipcode:String
    
}

