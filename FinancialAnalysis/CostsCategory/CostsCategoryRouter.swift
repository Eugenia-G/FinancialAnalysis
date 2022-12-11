//
//  CostsCategoryRouter.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 27.11.2022.
//

import UIKit

class CostsCategoryRouter: CostsCategoryRouterInput {
    var navigationController: UINavigationController?
    
    func showCostsView() {
        navigationController?.dismiss(animated: true)
    }
    
    func showAddFlow(navController: UINavigationController, type: AddType, category: String) {
        let interator = AddInteractor()
        let presenter = AddPresenter(addType: type, category: category)
        let view = AddViewController()
        let router = AddRouter()

        view.presenter = presenter
        presenter.interactor = interator
        presenter.router = router
        presenter.view = view
        
        router.navigationController = navController
        
        navController.present(view, animated: true)
    }
    
    func showAlert(title: String, subtitle: String?, action: [String : (UIAlertAction) -> Void]) {
        let alert = UIAlertController(title: title, message: subtitle ?? "", preferredStyle: .alert)
        for (key, value) in action {
            let action = UIAlertAction(title: key, style: .default, handler: value)
            alert.addAction(action)
        }
        navigationController?.present(alert, animated: true)
    }
}
