//
//  CostsCategoryRouretInput.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 27.11.2022.
//

import UIKit

protocol CostsCategoryRouterInput {
    var navigationController: UINavigationController? { get }
    
    func showCostsView()
    func showAddFlow(navController: UINavigationController, type: AddType, category: String)
    func showAlert(title: String, subtitle: String?, action: [String : (UIAlertAction) -> Void])
    func showGraphFlow(costs: [CostsCategory])
}
