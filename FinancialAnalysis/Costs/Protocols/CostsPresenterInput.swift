//
//  CostsPresenterInput.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 05.11.2022.
//

import UIKit

protocol CostsPresenterInput {
    func start()
    func add(navController: UINavigationController, type: AddType)
    func getCategories() -> [String]
    func getIncome() -> Double
    func deleteCategory(at index: Int, for category: String)
    func openCostsCategory(navController: UINavigationController, category: String)
}
