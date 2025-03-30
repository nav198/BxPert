//
//  NavigationHelper.swift
//  Bxpert
//
//  Created by Naveen on 27/03/25.
//

import Foundation

enum HomeNavigation {
    case seeReport
    case camera
    case mobile
    
}

enum ApiURl:String{
    case pdf = "https://fssservices.bookxpert.co/GeneratedPDF/Companies/nadc/2024-2025/BalanceSheet.pdf"
    case mobiles = "https://api.restful-api.dev/objects"
}

enum DataError:Error{
    case invalidData
    case invalidResponse
    case invalidURL
    case otherError(msg:String)
}
