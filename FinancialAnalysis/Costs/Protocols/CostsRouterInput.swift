//
//  CostsRouterInput.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 05.11.2022.
//

import UIKit

protocol CostsRouterInput{
    func showAddFlow(navController: UINavigationController, type: AddType)
    func showCostsCategoryFlow(navController: UINavigationController, category: String)
}
