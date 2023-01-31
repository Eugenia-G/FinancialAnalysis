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
            let income = Income()
            income.income = inc
            income.incomeDate = Date().rusFormatter
            realm.add(income)
        }
        
        let lastCostsIncome = Array(self.realm.objects(CostsIncome.self)).last?.costsIncome
        let costsIncome = CostsIncome()
        costsIncome.costsIncome = (lastCostsIncome ?? 0) + inc
        try! realm.write{
            realm.add(costsIncome)
        }
    }
    
    func addCostsCategory(category: String, name: String, number: String) -> Bool {
            let lastIncome = Array(self.realm.objects(CostsIncome.self)).last?.costsIncome
            let income = CostsIncome()
            income.costsIncome = (lastIncome ?? 0) - (Double(number) ?? 0)
            if income.costsIncome >= 0 {
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
