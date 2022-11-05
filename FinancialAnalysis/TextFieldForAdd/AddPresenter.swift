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
    
    func addButtonClick() {
        interactor?.addCategory(view?.getCategory() ?? "")
        router?.showCostsView()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "categoryAdd"), object: nil)
    }
}
