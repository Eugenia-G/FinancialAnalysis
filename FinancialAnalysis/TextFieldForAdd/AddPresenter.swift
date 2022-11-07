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
    
    init(addType: AddType) {
        self.addType = addType
    }
    
    func addButtonClick() {
        switch addType {
        case .category:
            interactor?.addCategory(view?.getCategory() ?? "")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "categoryAdd"), object: nil)
        case .income:
            interactor?.addIncome(view?.getIncome() ?? 0)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "incomeAdd"), object: nil)
        }
        router?.showCostsView()
    }
}
