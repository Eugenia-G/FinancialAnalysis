//
//  CostsInteractor.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 02.11.2022.
//

import Foundation
import RealmSwift

class CostsInteractor: CostsInteractorInput {
    private let realm = try! Realm()
    
    func getCategories() -> [String] {
        var categories: [String] = []
        let list = Array(realm.objects(CostsCategories.self))
        for element in list{
            categories.append(element.costsCategories)
        }
        return categories
    }
    
    func getIncome() -> Double {
        let lastIncome = Array(realm.objects(Income.self)).last?.income ?? 0
        return lastIncome
    }
    
    func deleteCategory(at index : Int) {
        self.realm.beginWrite()
        self.realm.delete(Array(realm.objects(CostsCategories.self))[index])
        do {
            try! self.realm.commitWrite()
        }
    }
}
