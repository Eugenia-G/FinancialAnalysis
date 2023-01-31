//
//  GraphPresenter.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 12.12.2022.
//

import UIKit

class GraphPresenter: GraphPresenterInput {
    var router: GraphRouterInput?
    var interactor: GraphInteractorInput?
    var view: GraphViewController?
    
    var type: GraphType?
    var costs: [CostsCategory]?
    
    init(type: GraphType? = .costs, costs: [CostsCategory]? = nil) {
        self.type = type
        self.costs = costs
    }
    
    func start() {
    }
    
    func getCostsForCategory() -> [CostsCategory]? {
        costs
    }
    
    func getIncome() -> [Income]? {
        interactor?.getIncome()
    }
    
    func getCosts() -> [CostsCategory]? {
        interactor?.getCosts()
    }
}

