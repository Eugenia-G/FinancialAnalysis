//
//  CostsPresenterInput.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 05.11.2022.
//

import UIKit

protocol CostsPresenterInput {
    func start()
    func addCostsCategory(navController: UINavigationController)
    func getCategories() -> [String]
    func deleteCategory(at index: Int)
}
