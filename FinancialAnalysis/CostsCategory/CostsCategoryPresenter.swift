//
//  CostsCategoryPresenter.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 27.11.2022.
//

import Foundation
import NotificationCenter


class CostsCategoryPresenter: CostsCategoryPresenterInput {
    var router: CostsCategoryRouterInput?
    var interactor: CostsCategoryInteractorInput?
    var view: CostsCategoryViewController?
    
    var category: String
    
    init(category: String) {
        self.category = category
    }
    
    func start() {
        view?.updateTable()
    }
    
    func getIncome() -> Double {
        return interactor?.getIncome() ?? 0
    }
    
    func getCostsCategory() -> [CostsCategory] {
        return interactor?.getCostsCategory(category) ?? []
    }
    
    func add(navController: UINavigationController, type: AddType) {
        router?.showAddFlow(navController: navController, type: type, category: category)
    }
    
    func showAlert(title: String, subtitle: String, action: [String : (UIAlertAction) -> Void]) {
        router?.showAlert(title: title, subtitle: subtitle, action: action)
    }
    
    func graphButtonDidTap(costs: [CostsCategory]) {
        router?.showGraphFlow(costs: costs)
    }
    
}
