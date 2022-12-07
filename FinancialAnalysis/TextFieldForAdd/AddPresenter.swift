//
//  AddPresenter.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 02.11.2022.
//

import Foundation
import NotificationCenter


class AddPresenter: AddPresenterInput {
    var router: AddRouterInput?
    var interactor: AddInteractorInput?
    var view: AddViewController?
    
    var addType: AddType
    var category: String?
    
    init(addType: AddType, category: String? = nil) {
        self.addType = addType
        self.category = category
    }
    
    func addButtonClick() {
        switch addType {
        case .category:
            interactor?.addCategory(view?.getCategory() ?? "")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "categoryAdd"), object: nil)
            router?.showCostsView()
        case .income:
            interactor?.addIncome(view?.getIncome() ?? 0)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "incomeAdd"), object: nil)
            router?.showCostsView()
        case .cost:
            interactor?.addCostsCategory(category: category ?? "", name: view?.getCategory() ?? "", number: view?.getNumber() ?? "")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "costAdd"), object: nil)
            router?.showCostsCategoryView()
        }
    }
}
