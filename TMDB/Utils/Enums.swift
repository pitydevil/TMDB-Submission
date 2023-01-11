//
//  Enum.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 11/01/23.
//

import Foundation

//MARK: - NETWORKING ENUMERATION DECLARATION
enum HTTPMethod: String {
    case get  = "GET"
    case post = "POST"
    case put  = "PUT"
}

enum ApplicationEndpoint {
    case getOrderList(orderStatus : String, userID : Int)
    case getDetailOrderID(orderID : Int)
    case getNearest(longitude : Double, latitude : Double)
    //case postOrder(order: [AddOrder])
    case getPetHotelDetail(petHotelID : Int)
  //  case getListMonitoring(MonitoringBody : MonitoringBody)
  //  case getPetHotelPackage(hotelPackageBody : HotelPackageBody)
 //   case getSearchListPetHotel(exploreSearchBody : ExploreSearchBody)
//    case getOrderAdd(order : OrderAdd)
}

enum genericHandlingError : Int {
    case objectNotFound  = 404
    case methodNotFound  = 405
    case tooManyRequest  = 429
    case success         = 200
    case unexpectedError = 500
}
