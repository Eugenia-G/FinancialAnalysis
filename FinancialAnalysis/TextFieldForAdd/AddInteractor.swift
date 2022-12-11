//
//  AddInteractor.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 02.11.2022.
//

import Foundation
import RealmSwift

class AddInteractor: AddInteractorInput {
    var presenter: AddInteractorOutput?
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
            income.incomeDate = Date().rusFormatter
            realm.add(income)
        }
    }
    
    func addCostsCategory(category: String, name: String, number: String) -> Bool {
            let lastIncome = Array(self.realm.objects(Income.self)).last?.income
            let income = Income()
            income.income = (lastIncome ?? 0) - (Double(number) ?? 0)
            if income.income >= 0 {
                try! realm.write{
                    realm.add(income)
                }
               writeCostsCategory(category: category, name: name, number: number)
                return true
            } else {
                return false
        }
    }
    
    func writeCostsCategory(category: String, name: String, number: String) {
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
