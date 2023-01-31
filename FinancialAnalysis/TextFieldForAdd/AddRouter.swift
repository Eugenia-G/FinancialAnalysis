//
//  AddRouter.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 25.01.2023.
//

import Foundation
import UIKit

class AddRouter: AddRouterInput{
    weak var viewController: AddViewController?
    var navigationController: UINavigationController?
    
    func showCostsView() {
        navigationController?.dismiss(animated: true)
    }
    
    func showCostsCategoryView(_ isCostAdd: Bool) {
        navigationController?.dismiss(animated: true)
    }
}

