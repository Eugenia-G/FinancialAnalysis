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
    
    func getIncome() -> Double {
        return interactor?.getIncome() ?? 0
    }
    
    func add(navController: UINavigationController, type: AddType) {
        router?.showAddFlow(navController: navController, type: type)
    }
    
    func deleteCategory(at index: Int) {
        interactor?.deleteCategory(at: index)
    }
}
