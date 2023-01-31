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
        let lastCostsIncome = Array(realm.objects(CostsIncome.self)).last?.costsIncome ?? 0
        return lastCostsIncome
    }
    
    func getCostsCategory(_ category: String) -> [CostsCategory] {
        let category = Array(realm.objects(CostsCategory.self)).filter({ $0.costCategory == category })
        return category
    }
    
    func deleteCost(at index : Int, for category: String) {
        self.realm.beginWrite()
        self.realm.delete(Array(realm.objects(CostsCategory.self)).filter({ $0.costCategory == category }).sorted(by: { $0.costsDate > $1.costsDate })[index])
        do {
            try! self.realm.commitWrite()
        }
    }
}
