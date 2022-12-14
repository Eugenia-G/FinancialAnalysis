//
//  CostsRouter.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 02.11.2022.
//

import Foundation
import UIKit

class CostsRouter: CostsRouterInput{
    weak var viewController: CostsViewController?
    
    func showAddFlow(navController: UINavigationController, type: AddType) {
        let interator = AddInteractor()
        let presenter = AddPresenter(addType: type)
        let view = AddViewController()
        let router = AddRouter()

        view.presenter = presenter
        presenter.interactor = interator
        presenter.router = router
        presenter.view = view
        
        router.navigationController = navController
        
        navController.present(view, animated: true)
    }
    
    func showCostsCategoryFlow(navController: UINavigationController, category: String) {
        let interator = CostsCategoryInteractor()
        let presenter = CostsCategoryPresenter(category: category)
        let view = CostsCategoryViewController()
        let router = CostsCategoryRouter()

        view.presenter = presenter
        presenter.interactor = interator
        presenter.router = router
        presenter.view = view
        
        router.navigationController = navController
        
        navController.show(view, sender: nil)
    }
}
