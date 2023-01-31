//
//  GraphPresenterInput.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 12.12.2022.
//

import UIKit

protocol GraphPresenterInput {
    var type: GraphType? { get }
    
    func getCostsForCategory() -> [CostsCategory]?
    func getIncome() -> [Income]?
    func getCosts() -> [CostsCategory]?
    func start()
}

