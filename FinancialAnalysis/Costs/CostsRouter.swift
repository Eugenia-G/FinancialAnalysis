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
    
    func showAddCostsCategoryFlow(navController: UINavigationController) {
        let interator = AddInteractor()
        let presenter = AddPresenter()
        let view = AddViewController()
        let router = AddRouter()

        view.presenter = presenter
        presenter.interactor = interator
        presenter.router = router
        presenter.view = view
        
        router.navigationController = navController
        
        navController.present(view, animated: true)
    }
}
