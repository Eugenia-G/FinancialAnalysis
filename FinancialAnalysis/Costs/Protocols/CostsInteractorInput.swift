//
//  CostsInteractorInput.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 05.11.2022.
//

import Foundation

protocol CostsInteractorInput {
    func getCategories() -> [String]
    func getIncome() -> Double 
}
