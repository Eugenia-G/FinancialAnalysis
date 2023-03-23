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
}
