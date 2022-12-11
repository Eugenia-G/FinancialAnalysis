//
//  Income.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 07.11.2022.
//

import UIKit
import RealmSwift

public class Income: Object {
    @objc dynamic var income: Double = 0
    @objc dynamic var incomeDate: String = ""
}
