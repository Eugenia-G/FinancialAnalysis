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
        let lastCostsIncome = Array(realm.objects(CostsIncome.self)).last?.costsIncome ?? 0
        return lastCostsIncome
    }
    
    func deleteCategory(at index : Int, for category: String) {
        self.realm.beginWrite()
        self.realm.delete(Array(realm.objects(CostsCategories.self))[index])
        do {
            try! self.realm.commitWrite()
        }
        
        let category = Array(realm.objects(CostsCategory.self)).filter({ $0.costCategory == category })
        for element in category {
            self.realm.beginWrite()
            self.realm.delete(element)
            do {
                try! self.realm.commitWrite()
            }
        }
    }
}
