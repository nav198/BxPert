//
//  MobilesModel.swift
//  Bxpert
//
//  Created by Naveen on 27/03/25.
//

import Foundation

struct MobilesModel:Codable{
    var id,name:String
    var data:MobileData?
}

struct MobileData:Codable{
    var color,capacity:String?
    var price:Double?
}
