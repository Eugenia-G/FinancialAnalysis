//
//  CostsCategoryInteractor.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 27.11.2022.
//

import Foundation
import RealmSwift

class CostsCategoryInteractor: CostsCategoryInteractorInput {
    private let realm = try! Realm()
    
    func getIncome() -> Double {
        let lastIncome = Array(realm.objects(Income.self)).last?.income ?? 0
        return lastIncome
    }
    
    func getCostsCategory(_ category: String) -> [CostsCategory] {
        let category = Array(realm.objects(CostsCategory.self)).filter({ $0.costCategory == category })
        return category
    }
    
    func deleteCost(at index : Int) {
        self.realm.beginWrite()
        self.realm.delete(Array(realm.objects(CostsCategory.self))[index])
        do {
            try! self.realm.commitWrite()
        }
    }
}
