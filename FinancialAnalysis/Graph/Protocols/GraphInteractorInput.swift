//
//  GraphInteractorInput.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 12.12.2022.
//

import Foundation

protocol GraphInteractorInput {
    func getIncome() -> [Income]
    func getCosts() -> [CostsCategory]
}

