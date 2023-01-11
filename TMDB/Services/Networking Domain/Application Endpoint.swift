//
//  Application Endpoint.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 11/01/23.
//

import Foundation


extension ApplicationEndpoint: Endpoint {
    var host: String {
        "www.fluffy.umkmbedigital.com"
    }

    var path: String {
        switch self {
        case .getOrderList:
            return "/public/api/reservation/order/list"
        case .getDetailOrderID:
            return "/public/api/reservation/order/detail"
        case .getNearest:
            return "/public/api/explore/get-nearest-pet-hotel"
        case .getPetHotelDetail:
            return "/public/api/reservation/pet_hotel/detail"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getOrderList:
            return .post
        case .getDetailOrderID:
            return .post
        case .getNearest:
            return .post
        case .getPetHotelDetail:
            return .post
        }
    }

    var body: [String : Any]? {
        switch self {
        case .getOrderList(let orderStatus, let userID):
            return [
                "order_status" : orderStatus,
                "user_id"      : userID
            ]
        case .getDetailOrderID(let orderID):
            return [
                "order_id" : orderID
            ]
        case .getNearest(let longitude, let latitude):
            return [
                "longitude" : longitude,
                "latitude"  : latitude
            ]
        case .getPetHotelDetail(let petHotelID):
            return [
                "pet_hotel_id" : petHotelID
            ]
        default:
            return nil
        }
    }
}
