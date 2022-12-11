//
//  AddRouterInput.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 05.11.2022.
//

import UIKit

protocol AddRouterInput {
    var navigationController: UINavigationController? { get }
    
    func showCostsView()
    func showCostsCategoryView(_ isCostAdd: Bool)
}
