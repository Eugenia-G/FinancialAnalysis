//
//  CostsCategoryPresenterInput.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 27.11.2022.
//

import Foundation
import UIKit

protocol CostsCategoryPresenterInput {
    var category: String { get }
    
    func start()
    func getIncome() -> Double
    func add(navController: UINavigationController, type: AddType)
    func getCostsCategory() -> [CostsCategory]
    func deleteCost(at index: Int)
    func showAlert(title: String, subtitle: String, action: [String : (UIAlertAction) -> Void])
    func graphButtonDidTap(costs: [CostsCategory])
}
