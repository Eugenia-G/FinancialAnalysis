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
}
