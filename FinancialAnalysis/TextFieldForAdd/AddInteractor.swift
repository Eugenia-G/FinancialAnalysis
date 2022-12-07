//
//  AddInteractor.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 02.11.2022.
//

import Foundation
import RealmSwift

class AddInteractor: AddInteractorInput {
    private let realm = try! Realm()
    
    func addCategory(_ category: String) {
        try! realm.write{
            let costsCategories = CostsCategories()
            costsCategories.costsCategories.append(category)
            realm.add(costsCategories)
        }
    }
    
    func addIncome(_ inc: Double) {
        try! realm.write{
            let lastIncome = Array(realm.objects(Income.self)).last?.income
            let income = Income()
            income.income = (lastIncome ?? 0) + inc
            realm.add(income)
        }
    }
    
    func addCostsCategory(category: String, name: String, number: String) {
        try! realm.write{
            let costsCategory = CostsCategory()
            costsCategory.costCategory.append(category)
            costsCategory.costsName.append(name)
            costsCategory.costsDate.append(Date().rusFormatter)
            costsCategory.costsNumber.append(number)
            realm.add(costsCategory)
        }
    }
}
