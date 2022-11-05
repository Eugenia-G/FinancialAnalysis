//
//  CostsPresenter.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 02.11.2022.
//

import UIKit
//import  RealmSwift

class CostsPresenter: CostsPresenterInput {
    var router: CostsRouterInput?
    var interactor: CostsInteractorInput?
    var view: CostsViewController?
    
    func start() {
//        let realm = try! Realm()
//        try! realm.write {
//          realm.deleteAll()
//        }
        
        view?.updateTable()
    }
    
    func getCategories() -> [String] {
        return interactor?.getCategories() ?? []
    }
    
    func addCostsCategory(navController: UINavigationController) {
        router?.showAddCostsCategoryFlow(navController: navController)
    }
    
    func deleteCategory(at index: Int) {
        interactor?.deleteCategory(at: index)
    }
}
