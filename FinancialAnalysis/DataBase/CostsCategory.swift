//
//  CostsCategory.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 27.11.2022.
//

import Foundation
import RealmSwift

public class CostsCategory: Object {
    @objc dynamic var costCategory: String = ""
    @objc dynamic var costsName: String = ""
    @objc dynamic var costsDate: String = ""
    @objc dynamic var costsNumber: String = ""
}

