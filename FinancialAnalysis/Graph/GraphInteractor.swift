//
//  GraphInteractor.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 12.12.2022.
//

import Foundation
import RealmSwift

class GraphInteractor: GraphInteractorInput {
    private let realm = try! Realm()
    
    func getIncome() -> [Income] {
        let income = Array(realm.objects(Income.self))
        return income
    }
    
    func getCosts() -> [CostsCategory] {
        Array(realm.objects(CostsCategory.self))
    }
}
