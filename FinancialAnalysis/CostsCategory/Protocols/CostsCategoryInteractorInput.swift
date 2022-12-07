//
//  CostsCategoryInteractorInput.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 27.11.2022.
//

import Foundation

protocol CostsCategoryInteractorInput {
    func getIncome() -> Double
    func getCostsCategory(_ category: String) -> [CostsCategory]
    func deleteCost(at index : Int)
}

