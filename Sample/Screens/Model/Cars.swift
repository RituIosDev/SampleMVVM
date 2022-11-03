//
//  Cars.swift
//  BellTechnical
//
//  Created by Ritu on 2022-08-31.
//
import Foundation

typealias Cars = [Car]

struct Car: Codable{
    var customerPrice: Double
    var make: String
    var marketPrice: Double
    var model: String
    var rating: Int
    var prosList: [String]
    var consList: [String]
    
    enum CodingKeys: String, CodingKey{
        case customerPrice = "customerPrice"
        case make = "make"
        case marketPrice = "marketPrice"
        case model = "model"
        case rating = "rating"
        case prosList = "prosList"
        case consList = "consList"
    }
}
