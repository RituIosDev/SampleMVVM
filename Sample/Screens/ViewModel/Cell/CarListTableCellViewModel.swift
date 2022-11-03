//
//  CarListTableCellViewModel.swift
//  BellTechnical
//
//  Created by Ritu on 2022-09-01.
//

import Foundation
import UIKit

struct CarListTableCellViewModel {
    var lblCarPrice: Double
    var lblCarName: String
    var imgVwCar: UIImage
    var rating: Int
    var expandedCell = 0
    var arrPros:[String]
    var arrCons:[String]
}
